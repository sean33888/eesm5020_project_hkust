#!/usr/bin/python3

import argparse
import random
import sys

def generate_params(seed=None):
    # Set random seed if provided
    if seed is not None:
        random.seed(seed)
        print(f"Using seed: {seed}")
    output_file = "/dfs/usrhome/kjyu/Desktop/eesm5020/design_project/tb/tc_data/param_" + str(seed) + ".txt"

    str_to_data = ""

    for i in range(2):
        list_param = []
        prec = random.randint(0, 3)
        list_param.append(str(prec))

        tmp_k = random.randint(0, 127)
        tmp_k= f"{tmp_k:02x}"
        list_param.append(str(tmp_k))
        for _ in range(3):
            temp = random.randint(0, 255)
            temp_h= f"{temp:02x}"
            list_param.append(str(temp_h))

        str_to_data += " ".join(list_param) + "\n"

    # write to output
    with open(output_file, 'w') as fpw:
        fpw.write(str_to_data)

def generate_plaintext(num_lines, seed=None):
    """
    Generate num_lines of random 8-bit plaintext values and write to output_file in hex format.
    Each line contains a two-digit lowercase hex value (e.g., 'ab', '35').
    If seed is provided, initialize the random number generator with it.
    """
    # Validate num_lines
    if num_lines <= 0:
        raise ValueError("Number of lines must be positive")

    # Set random seed if provided
    if seed is not None:
        random.seed(seed)
        print(f"Using seed: {seed}")

    output_file = "/dfs/usrhome/kjyu/Desktop/eesm5020/design_project/tb/tc_data/plaintext_" + str(seed) + ".txt"
    # Generate random 8-bit values and write to file
    with open(output_file, 'w') as f:
        for _ in range(num_lines):
            value = random.randint(0, 255)  # 8-bit value (0 to 255)
            hex_value = f"{value:02x}"     # Two-digit lowercase hex
            f.write(hex_value + '\n')
    
    print(f"Successfully generated {num_lines} plaintext values to {output_file}")

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(
        description="Generate random 8-bit plaintext values in hex format to a file."
    )
    parser.add_argument('-n', 
        "--num_lines",
        type=int,
        required=True,
        help="Number of plaintext values (lines) to generate"
    )
    parser.add_argument('-s',
        "--seed",
        type=int,
        default=None,
        help="Seed for random number generator (optional, integer)"
    )

    # Parse arguments
    args = parser.parse_args()

    # Generate plaintext
    generate_plaintext(args.num_lines, args.seed)

    # Generate parameters
    generate_params(args.seed)
    

main()
