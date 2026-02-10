#!/usr/bin/env python3
"""
Azure Key Vault Bulk Update Script
===================================
This script reads secrets from an Excel file and updates them in specified Azure Key Vaults.
It checks the "Need to Update" column to determine if each secret should be updated.

Prerequisites:
- pip install openpyxl azure-identity azure-keyvault-secrets
- Azure CLI authentication or managed identity
- Proper permissions to update Key Vault secrets

Excel File Format:
- Column 1: Secret Name (key)
- Column 2: Secret Value
- Column 3: Need to Update (Yes/No, True/False, 1/0)
"""

import argparse
import logging
import sys
from pathlib import Path
from typing import List, Dict, Tuple, Optional
import openpyxl
from azure.identity import DefaultAzureCredential, AzureCliCredential
from azure.keyvault.secrets import SecretClient
from azure.core.exceptions import AzureError

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('keyvault_update.log')
    ]
)
logger = logging.getLogger(__name__)

# Environment Configuration - Key Vault mappings for EYX project
ENVIRONMENT_CONFIG = {
    'dev1': {
        'keyvault': 'USEDCXS05HAKV03',
        'description': 'Development Environment 1'
    },
    'dev2': {
        'keyvault': 'USEDCXS05HAKV04',
        'description': 'Development Environment 2'
    },
    'dev3': {
        'keyvault': 'USEDCXS05HAKV05',
        'description': 'Development Environment 3'
    },
    'qa': {
        'keyvault': 'USEQCXS05HAKV02',
        'description': 'QA Environment'
    },
    'uat-lab': {
        'keyvault': 'USEUEYXU01AKV02',
        'description': 'UAT Lab Environment'
    },
    'uat-pilot': {
        'keyvault': 'USEUEYXU01AKV03',
        'description': 'UAT Pilot Environment'
    },
    'uat-prod': {
        'keyvault': 'USEUEYXU01AKV04',
        'description': 'UAT Production Environment'
    },
    'prod-lab': {
        'keyvault': 'USEPEYXP01AKV02',
        'description': 'Production Lab Environment'
    },
    'prod-pilot': {
        'keyvault': 'USEPEYXP01AKV03',
        'description': 'Production Pilot Environment'
    },
    'prod': {
        'keyvault': 'USEPEYXP01AKV04',
        'description': 'Production Environment'
    }
}


class KeyVaultUpdater:
    """Manages updating Azure Key Vault secrets from Excel data."""
    
    def __init__(self, use_cli_auth: bool = False):
        """
        Initialize the KeyVaultUpdater.
        
        Args:
            use_cli_auth: If True, use Azure CLI authentication only
        """
        try:
            if use_cli_auth:
                self.credential = AzureCliCredential()
                logger.info("Using Azure CLI authentication")
            else:
                self.credential = DefaultAzureCredential()
                logger.info("Using Default Azure credential chain")
        except Exception as e:
            logger.error(f"Failed to initialize Azure credentials: {e}")
            raise
    
    def read_excel_file(self, file_path: str, sheet_name: str = None) -> List[Dict[str, str]]:
        """
        Read secrets from Excel file.
        
        Args:
            file_path: Path to the Excel file
            sheet_name: Name of the sheet to read (default: active sheet)
            
        Returns:
            List of dictionaries containing secret data
        """
        logger.info(f"Reading Excel file: {file_path}")
        
        if not Path(file_path).exists():
            raise FileNotFoundError(f"Excel file not found: {file_path}")
        
        try:
            workbook = openpyxl.load_workbook(file_path, data_only=True)
            worksheet = workbook[sheet_name] if sheet_name else workbook.active
            
            logger.info(f"Reading from sheet: {worksheet.title}")
            
            # Get headers from first row
            headers = []
            for cell in worksheet[1]:
                if cell.value:
                    headers.append(str(cell.value).strip())
            
            logger.info(f"Found columns: {headers}")
            
            # Find required columns (case-insensitive)
            key_col_idx = None
            value_col_idx = None
            update_col_idx = None
            
            for idx, header in enumerate(headers):
                header_lower = header.lower()
                # Look for key/name column
                if 'secret' in header_lower and 'name' in header_lower:
                    # Prefer "Secret Name" over other matches
                    key_col_idx = idx
                elif key_col_idx is None and ('key' in header_lower or 'name' in header_lower):
                    key_col_idx = idx
                # Look for value column - be flexible with different naming conventions
                elif value_col_idx is None and ('value' in header_lower or 'password' in header_lower or 
                                                  'secret' in header_lower or 'data' in header_lower or
                                                  'content' in header_lower):
                    # Skip columns that are clearly keys/names
                    if 'name' not in header_lower and 'key' not in header_lower:
                        value_col_idx = idx
                # Look for update flag column
                elif 'need' in header_lower and 'update' in header_lower:
                    update_col_idx = idx
            
            if key_col_idx is None:
                raise ValueError(f"Could not find 'Key' or 'Name' column in Excel file. Found columns: {headers}")
            if value_col_idx is None:
                raise ValueError(f"Could not find 'Value' or 'Password' column in Excel file. Found columns: {headers}")
            if update_col_idx is None:
                raise ValueError(f"Could not find 'Need to Update' column in Excel file. Found columns: {headers}")
            
            logger.info(f"Key column: {headers[key_col_idx]} (index {key_col_idx})")
            logger.info(f"Value column: {headers[value_col_idx]} (index {value_col_idx})")
            logger.info(f"Update column: {headers[update_col_idx]} (index {update_col_idx})")
            
            # Read data rows
            secrets = []
            for row_idx, row in enumerate(worksheet.iter_rows(min_row=2, values_only=True), start=2):
                if not row or len(row) <= max(key_col_idx, value_col_idx, update_col_idx):
                    continue
                
                key = row[key_col_idx]
                value = row[value_col_idx]
                need_update = row[update_col_idx]
                
                # Skip empty rows
                if not key:
                    continue
                
                # Parse the "Need to Update" field
                should_update = self._parse_boolean(need_update)
                
                if should_update:
                    # Sanitize secret name (Key Vault naming rules)
                    sanitized_key = self._sanitize_secret_name(str(key))
                    
                    secrets.append({
                        'original_key': str(key),
                        'key': sanitized_key,
                        'value': str(value) if value is not None else '',
                        'row': row_idx
                    })
                    logger.debug(f"Row {row_idx}: {sanitized_key} - Marked for update")
                else:
                    logger.debug(f"Row {row_idx}: {key} - Skipped (not marked for update)")
            
            logger.info(f"Found {len(secrets)} secrets marked for update")
            return secrets
            
        except Exception as e:
            logger.error(f"Error reading Excel file: {e}")
            raise
    
    def _parse_boolean(self, value) -> bool:
        """
        Parse various boolean representations.
        
        Args:
            value: Value to parse
            
        Returns:
            Boolean value
        """
        if value is None:
            return False
        
        if isinstance(value, bool):
            return value
        
        if isinstance(value, (int, float)):
            return value != 0
        
        str_value = str(value).strip().lower()
        return str_value in ['yes', 'y', 'true', '1', 'x']
    
    def _sanitize_secret_name(self, name: str) -> str:
        """
        Sanitize secret name to comply with Key Vault naming rules.
        Key Vault secret names can only contain alphanumeric characters and hyphens.
        
        Args:
            name: Original secret name
            
        Returns:
            Sanitized secret name
        """
        # Replace invalid characters with hyphens
        sanitized = ''.join(c if c.isalnum() or c == '-' else '-' for c in name)
        # Remove leading/trailing hyphens
        sanitized = sanitized.strip('-')
        # Collapse multiple hyphens
        while '--' in sanitized:
            sanitized = sanitized.replace('--', '-')
        
        if sanitized != name:
            logger.warning(f"Secret name sanitized: '{name}' -> '{sanitized}'")
        
        return sanitized
    
    def update_keyvault(self, vault_url: str, secrets: List[Dict[str, str]], 
                       dry_run: bool = False) -> Tuple[int, int]:
        """
        Update secrets in a Key Vault.
        
        Args:
            vault_url: Key Vault URL (e.g., https://my-keyvault.vault.azure.net/)
            secrets: List of secret dictionaries
            dry_run: If True, only simulate the update
            
        Returns:
            Tuple of (successful_count, failed_count)
        """
        logger.info(f"{'[DRY RUN] ' if dry_run else ''}Updating Key Vault: {vault_url}")
        
        if not vault_url.startswith('https://'):
            vault_url = f"https://{vault_url}.vault.azure.net/"
        
        try:
            client = SecretClient(vault_url=vault_url, credential=self.credential)
            
            success_count = 0
            failed_count = 0
            
            for secret_data in secrets:
                secret_name = secret_data['key']
                secret_value = secret_data['value']
                
                try:
                    if dry_run:
                        logger.info(f"[DRY RUN] Would update secret: {secret_name}")
                        success_count += 1
                    else:
                        client.set_secret(secret_name, secret_value)
                        logger.info(f"✓ Successfully updated secret: {secret_name}")
                        success_count += 1
                        
                except AzureError as e:
                    logger.error(f"✗ Failed to update secret '{secret_name}': {e}")
                    failed_count += 1
                except Exception as e:
                    logger.error(f"✗ Unexpected error updating secret '{secret_name}': {e}")
                    failed_count += 1
            
            return success_count, failed_count
            
        except Exception as e:
            logger.error(f"Failed to connect to Key Vault {vault_url}: {e}")
            raise
    
    def update_multiple_keyvaults(self, vault_urls: List[str], secrets: List[Dict[str, str]], 
                                 dry_run: bool = False) -> Dict[str, Tuple[int, int]]:
        """
        Update secrets in multiple Key Vaults.
        
        Args:
            vault_urls: List of Key Vault URLs
            secrets: List of secret dictionaries
            dry_run: If True, only simulate the update
            
        Returns:
            Dictionary mapping vault URL to (success_count, failed_count)
        """
        results = {}
        
        for vault_url in vault_urls:
            try:
                success, failed = self.update_keyvault(vault_url, secrets, dry_run)
                results[vault_url] = (success, failed)
            except Exception as e:
                logger.error(f"Failed to update vault {vault_url}: {e}")
                results[vault_url] = (0, len(secrets))
        
        return results


def list_available_environments():
    """Display available environments and their Key Vaults."""
    print("\n" + "="*70)
    print("AVAILABLE ENVIRONMENTS")
    print("="*70)
    
    # Group by environment type
    dev_envs = {k: v for k, v in ENVIRONMENT_CONFIG.items() if k.startswith('dev')}
    qa_envs = {k: v for k, v in ENVIRONMENT_CONFIG.items() if k.startswith('qa')}
    uat_envs = {k: v for k, v in ENVIRONMENT_CONFIG.items() if k.startswith('uat')}
    prod_envs = {k: v for k, v in ENVIRONMENT_CONFIG.items() if k.startswith('prod')}
    
    if dev_envs:
        print("\n📦 Development:")
        for env, config in dev_envs.items():
            print(f"  {env:15} -> {config['keyvault']:20} ({config['description']})")
    
    if qa_envs:
        print("\n🧪 QA:")
        for env, config in qa_envs.items():
            print(f"  {env:15} -> {config['keyvault']:20} ({config['description']})")
    
    if uat_envs:
        print("\n🔧 UAT:")
        for env, config in uat_envs.items():
            print(f"  {env:15} -> {config['keyvault']:20} ({config['description']})")
    
    if prod_envs:
        print("\n🚀 Production:")
        for env, config in prod_envs.items():
            print(f"  {env:15} -> {config['keyvault']:20} ({config['description']})")
    
    print("\n" + "="*70 + "\n")


def resolve_keyvaults(env_names: Optional[List[str]], kv_names: Optional[List[str]]) -> List[str]:
    """
    Resolve environment names or Key Vault names to Key Vault names.
    
    Args:
        env_names: List of environment names (e.g., 'dev1', 'qa', 'prod')
        kv_names: List of Key Vault names or URLs
        
    Returns:
        List of resolved Key Vault names or URLs
    """
    keyvaults = []
    
    # Process environment names
    if env_names:
        for env_name in env_names:
            env_lower = env_name.lower()
            if env_lower in ENVIRONMENT_CONFIG:
                kv = ENVIRONMENT_CONFIG[env_lower]['keyvault']
                keyvaults.append(kv)
                logger.info(f"Resolved environment '{env_name}' to Key Vault: {kv}")
            else:
                logger.warning(f"Unknown environment: {env_name}. Will treat as Key Vault name.")
                keyvaults.append(env_name)
    
    # Process direct Key Vault names
    if kv_names:
        keyvaults.extend(kv_names)
    
    return keyvaults


def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        description='Update Azure Key Vault secrets from an Excel file',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # List available environments
  python update_keyvault_from_excel.py --list-environments
  
  # Update using environment names (dry run)
  python update_keyvault_from_excel.py -f kv_imputs.xlsx -e dev1 --dry-run
  
  # Update multiple environments
  python update_keyvault_from_excel.py -f kv_imputs.xlsx -e dev1 qa prod
  
  # Update using Key Vault names directly
  python update_keyvault_from_excel.py -f kv_imputs.xlsx -kv USEDCXS05HAKV03
  
  # Mix environments and direct Key Vault names
  python update_keyvault_from_excel.py -f kv_imputs.xlsx -e dev1 -kv CUSTOM-KV-NAME
  
  # Update using full URLs with CLI authentication
  python update_keyvault_from_excel.py -f kv_imputs.xlsx -kv https://my-kv.vault.azure.net/ --use-cli-auth
        """
    )
    
    parser.add_argument(
        '-f', '--file',
        help='Path to the Excel file containing secrets'
    )
    
    parser.add_argument(
        '-s', '--sheet',
        default=None,
        help='Sheet name to read from (default: active sheet)'
    )
    
    parser.add_argument(
        '-e', '--environments',
        nargs='+',
        help='Environment name(s) to update (dev1, dev2, dev3, qa, uat-lab, uat-pilot, uat-prod, prod-lab, prod-pilot, prod)'
    )
    
    parser.add_argument(
        '-kv', '--keyvaults',
        nargs='+',
        help='Key Vault name(s) or URL(s) to update (alternative to --environments)'
    )
    
    parser.add_argument(
        '--list-environments',
        action='store_true',
        help='List all available environments and exit'
    )
    
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Simulate the update without making actual changes'
    )
    
    parser.add_argument(
        '--use-cli-auth',
        action='store_true',
        help='Use Azure CLI authentication only'
    )
    
    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Enable verbose logging'
    )
    
    return parser.parse_args()


def main():
    """Main execution function."""
    args = parse_arguments()
    
    # Set logging level
    if args.verbose:
        logger.setLevel(logging.DEBUG)
    
    # Handle list environments command
    if args.list_environments:
        list_available_environments()
        return 0
    
    # Validate required arguments
    if not args.file:
        logger.error("Error: --file (-f) is required")
        list_available_environments()
        return 1
    
    if not args.environments and not args.keyvaults:
        logger.error("Error: Either --environments (-e) or --keyvaults (-kv) must be specified")
        list_available_environments()
        return 1
    
    try:
        # Resolve Key Vaults from environments or direct names
        keyvaults = resolve_keyvaults(args.environments, args.keyvaults)
        
        if not keyvaults:
            logger.error("No Key Vaults specified or resolved")
            return 1
        
        # Remove duplicates while preserving order
        keyvaults = list(dict.fromkeys(keyvaults))
        
        logger.info(f"Target Key Vaults: {', '.join(keyvaults)}")
        
        # Initialize updater
        updater = KeyVaultUpdater(use_cli_auth=args.use_cli_auth)
        
        # Read secrets from Excel
        secrets = updater.read_excel_file(args.file, args.sheet)
        
        if not secrets:
            logger.warning("No secrets found marked for update. Exiting.")
            return 0
        
        # Confirm before proceeding (unless dry run)
        if not args.dry_run:
            print(f"\n{'='*60}")
            print(f"About to update {len(secrets)} secrets in {len(keyvaults)} Key Vault(s):")
            for kv in keyvaults:
                # Check if this is a known environment
                env_name = None
                for env, config in ENVIRONMENT_CONFIG.items():
                    if config['keyvault'] == kv:
                        env_name = f"{env} ({config['description']})"
                        break
                
                if env_name:
                    print(f"  - {kv} [{env_name}]")
                else:
                    print(f"  - {kv}")
            print(f"{'='*60}\n")
            
            response = input("Do you want to proceed? (yes/no): ").strip().lower()
            if response not in ['yes', 'y']:
                logger.info("Update cancelled by user")
                return 0
        
        # Update Key Vaults
        results = updater.update_multiple_keyvaults(keyvaults, secrets, args.dry_run)
        
        # Print summary
        print(f"\n{'='*60}")
        print("UPDATE SUMMARY")
        print(f"{'='*60}")
        
        total_success = 0
        total_failed = 0
        
        for vault_url, (success, failed) in results.items():
            print(f"\n{vault_url}:")
            print(f"  ✓ Successful: {success}")
            print(f"  ✗ Failed: {failed}")
            total_success += success
            total_failed += failed
        
        print(f"\n{'='*60}")
        print(f"TOTAL: {total_success} successful, {total_failed} failed")
        print(f"{'='*60}\n")
        
        return 0 if total_failed == 0 else 1
        
    except FileNotFoundError as e:
        logger.error(f"File not found: {e}")
        return 1
    except ValueError as e:
        logger.error(f"Invalid data: {e}")
        return 1
    except Exception as e:
        logger.error(f"Unexpected error: {e}", exc_info=True)
        return 1


if __name__ == '__main__':
    sys.exit(main())
