import sys

if len(sys.argv) != 3:
    print('Usage: instance_to_dzn.py <input_file> <output_file>')
    sys.exit(1)

input_filename = sys.argv[1]
output_filename = sys.argv[2]

with open(input_filename, 'r') as f_in:
    lines = f_in.read().splitlines()

    split = lines[0].split(' ')
    w = split[0]
    h = split[1]

    n = lines[1]

    DX = []
    DY = []

    for i in range(int(n)):
        split = lines[i+2].split(' ')
        DX.append(int(split[0]))
        DY.append(int(split[1]))

    with open(output_filename, 'w') as f_out:
        f_out.write('w = {};\n'.format(w))
        f_out.write('h = {};\n'.format(h))
        f_out.write('n = {};\n'.format(n))
        
        f_out.write('DX = {};\n'.format(DX))
        f_out.write('DY = {};\n'.format(DY))
        

