# Define the table of operation codes for VAX instructions
opcode_table = {
    'movb': '90',
    'movl': 'd0',  
}

def convert_to_hexadecimal(instruction):
    parts = instruction.split()
    mnemonic = parts[0]
    if mnemonic not in opcode_table:
        return None  # Unknown instruction
    opcode = opcode_table[mnemonic]
    # For simplicity, assume the immediate value is always in the next part
    immediate_value = '{:02X}'.format(int(parts[1], 10))
    # For simplicity, assume the register is always the last part
    register = '{:02X}'.format(int(parts[-1][1:], 10))
    return opcode + immediate_value + register

def vax_to_hex(source_code):
    machine_code = []
    lines = source_code.split('\n')
    for line in lines:
        line = line.strip()
        if line:
            hex_code = convert_to_hexadecimal(line)
            if hex_code is None:
                print(f"Unknown instruction: {line}")
            else:
                machine_code.append(hex_code)
    return machine_code

def main():
    source_code = """
    movb $0, r0
    addb2 $1, r1
    # Add more instructions as needed
    """
    machine_code = vax_to_hex(source_code)
    if machine_code:
        print("Machine code:")
        for code in machine_code:
            print(code)

if __name__ == "__main__":
    main()
