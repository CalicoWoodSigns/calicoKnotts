#!/bin/bash

# Script to update datasource names from calicowoodsignsdsn to calicoknottsdsn
# Run this in the project directory

echo "Updating datasource names in ColdFusion files..."

# Find and replace in all .cfm and .cfml files
find . -name "*.cfm*" -type f -exec sed -i '' 's/calicowoodsignsdsn/calicoknottsdsn/g' {} \;

echo "Updated datasource names from 'calicowoodsignsdsn' to 'calicoknottsdsn'"
echo "Files updated:"
grep -l "calicoknottsdsn" *.cfm* 2>/dev/null || echo "No .cfm/.cfml files found in current directory"

echo "Verification - checking for any remaining old datasource references:"
grep -n "calicowoodsignsdsn" *.cfm* 2>/dev/null || echo "✅ No old datasource references found"
