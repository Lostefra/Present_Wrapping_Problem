import argparse
import numpy as np
import matplotlib.pyplot as plt
import random
from matplotlib.patches import Rectangle

parser = argparse.ArgumentParser(description='Argument parser')
parser.add_argument("-f", "--file_name", help="Filename", required = True, type=str)
args = parser.parse_args()

def main():		
	file = open(args.file_name,"r") 
		
	# Read the first line which contains the width and the height of the paper roll
	first_line = file.readline().strip().split(" ")
	
	width = int(first_line[0])
	height = int(first_line[1])

	# Read the second line which contains the number of necessary pieces of paper to cut off
	number_of_pieces = int(file.readline().strip())
	
	# Read all the remaining lines which contains the horizontal and vertical dimensionof the i-th piece of paper
	remaining_lines = file.readlines()
	# To remove empty lines
	remaining_lines = [line.strip() for line in remaining_lines if line.strip()]
	
	pieces = []
	
	for i,line in enumerate(remaining_lines):
		line = line.split()
		pieces.append([int(line[0]),int(line[1]),int(line[2]),int(line[3])])

		
	fig = plt.figure(figsize=(5 + (width//8) ,5 + (height//8)))
	ax = fig.gca(title = "Solution")
	for i in range(number_of_pieces):
		color = ["#"+''.join([random.choice('0123456789ABCDEF') for j in range(6)])]
		sq = Rectangle((pieces[i][2],pieces[i][3]),pieces[i][0],pieces[i][1],fill = True,color=color[0], alpha=.3 )
		ax.add_patch(sq)
	plt.plot()
	plt.show()
		
	
	file.close() 
		
if __name__ == "__main__":
	main()
