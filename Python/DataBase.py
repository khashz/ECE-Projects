def main():
	choice = displayMenuandReturnType() # choice will hold which dataBase
	satisfaction = raw_input("Do you want to continue with this Data Base Type? 'yes' or 'no':  ")
	if satisfaction == "yes":
		if (choice == "1"):
			dictionary()
		elif (choice == "2"):
			list()
		elif (choice == "3"):
			bst()
	else:
		again = raw_input("Do you want to try again? 'yes' or 'no' to exit:  ")
		if again == "yes":
			main()
		else:
			exit()
		
	    
def displayMenuandReturnType():
	print "What kind of Data Base do you want?"
	print "type in the number corresponding to the DataBase"
	print" 1.... Dictionary"
	print" 2.... List"
	print" 3.... Binary Search Trees"
	choice = raw_input("Number here: ")
	return choice
	
	
def displayMenuforCommandDict():
	print " "
	print "You can perform Three operations for each Data type..."
	print " 1 for GET a value from the data base"
	print " 2 for SET a value to the data base"
	print " 3 for PRINT, prints the data base in order"
	print " 4 for EXIT"
	command = raw_input("Number here: ")
	return command
	
def displayMenuforCommandList():
	print " "
	print "You can perform Three operations for each Data type..."
	print " 1 for GET a value from the data base"
	print " 2 for SET a value to the data base"
	print " 3 for PRINT, prints the data base in order"
	print " 4 for SORTING the list"
	print " 5 for EXIT"
	command = raw_input("Number here: ")
	return command
	
	
# implementation of the dictionary structure
def dictionary():  
	print "The dictionary will be arranged using Keys and values... Example"
	print "       KEYS			VALUES 		"
	print "       Math			  90		"
	print "       Science		  86		"
	print " Getting will be based on the keys and setting will update the values"
	print " "
	dict = {}
	while True:
  		command = displayMenuforCommandDict()
  		if command == "1": # GET
  			key = raw_input("Input a key: ")
  			print dict.get(key, "no matching key in array")
  		elif command == "2": # SET
  			key = raw_input("Input a key: ")
  			value = raw_input("Input a value: ")
			dict.update({key:value})
			dict[key] = value
  		elif command == "3": # PRINT
			print(dict)
  		elif command == "4": # EXIT
  			print "Exiting the Array"
			break		

# list implementation
def	list():
	print "The list holds  any type of user input"
	from collections import deque
	list =([])
	while True:
  		command = displayMenuforCommandList()
  		if command == "1": # GET the position
  			key = raw_input("Input a key: ")
  			list.index(key)
  		elif command == "2": # SET
  			value = raw_input("Input a value: ")
			list.append(value)
  		elif command == "3": # PRINT
			print list
		elif command == "4": # sort
			list.sort()
  		elif command == "5": # EXIT 		
  			print "Exiting the Array"
			break	
"""
def BST():
	print "The BST will be arranged using strings"
	print "Set will add a string into our tree, Get will return the depth of the value"
	print " "
	while True:
  		command = displayMenuforCommand()
  		if command == "1": # GET
  			key = raw_input("Input a value: ")
  		elif command == "2": # SET
  			key = raw_input("Input a value: ")
			node.insert(key)
  		elif command == "3": # PRINT
  			choice = raw_input(" enter 1 for inorder, 2 for post order, 3 for pre order")
			if (choice == "1"): #inorder print
				node.print_tree_inorder()
			elif (choice == "2"): # post order print
				node.print_tree_postorder()	
			elif (choice == "3"): # preorder print
				node.print_tree_preorder()
  		elif command == "4": # EXIT
  			print "Exiting the Array"
			break	
	
	
	
class Node: # declaration of our Nodes
	def __init__(self, value):
		self.left = None
        self.right = None
        self.value = value

def insert(self, value):
	if value < self.value: #if the value provided is smaller than the current value
		if self.left is None:	
			self.left = Node(value)
		else:
			self.left.insert(value)
	else:
		if self.right is None:
			self.right = Node(value)
		else:
			self.right.insert(value)
          
def print_tree_inorder(self): # inorder print traversal
	if self.left: # if we have a left child
	    self.left.print_tree_inorder()	# recursively send it onto the left branch
    	print self.value
	if self.right:  # if we have a right child
  	    self.right.print_tree_inorder()	# recursive call to the right branch

def print_tree_postorder(self): # postorder print traversal
	if self.left: # if we have a left child
	    self.left.print_tree_postorder()	# recursively send it onto the left branch
	if self.right:  # if we have a right child
  	    self.right.print_tree_postorder()	# recursive call to the right branch
  	print self.value

def print_tree_preorder(self): # preorder print traversal
    print self.value
	if self.left: # if we have a left child
	    self.left.print_tree_preorder()	# recursively send it onto the left branch
	if self.right:  # if we have a right child
  	    self.right.print_tree_preorder()	# recursive call to the right branch
"""


if __name__ == "__main__":
    main()
