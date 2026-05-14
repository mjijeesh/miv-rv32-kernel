
import shutil
import sys
import subprocess
import platform


import argparse
import io
import os
import zipfile
import git
import requests
import yaml
import datetime
import glob
import re





def execute_command(cmd):
    """Executes a system command and streams the output, similar to exe_sys_cmd."""
    # Derived from logic in build_gateware.py
    proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    for line in proc.stdout:
        print(line.decode('ascii'), end='')
    proc.wait()
    return proc.returncode



def run_design_flow(config_path):
    # 1. Load YAML data
    with open(config_path, 'r') as f:
        data = yaml.safe_load(f)
    
    params = data['libero_params']
    
    # 2. Define the tool path 
    # Libero usually needs to be in your system PATH
    libero_cmd = "libero" 
    
    # 3. Construct the arguments string
    # Your TCL script expects arguments via $argv [lindex $argv 0..2]
    tcl_script = params['script_path']
    #args = f"{params['config']} {params['design_flow']} {params['die_type']}"
    args = f"{params['config']} {params['design_flow']} {params['die_type']} {params['hw_platform']}"
    
    # 4. Format for Libero Batch Mode
    # Syntax: libero SCRIPT:myscript.tcl "SCRIPT_ARGS:arg1 arg2 arg3"
    full_cmd = f'{libero_cmd} SCRIPT:{tcl_script} "SCRIPT_ARGS:{args}"'
    
    print(f"Executing: {full_cmd}")
    
    result = execute_command(full_cmd)
    
    if result == 0:
        print("Libero script finished successfully.")
    else:
        print(f"Libero failed with exit code {result}.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python run_libero.py <config.yaml>")
    else:
        run_design_flow(sys.argv[1])