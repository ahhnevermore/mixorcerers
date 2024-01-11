class_name  Set
var dict

func _init(list):
	if list.size()>0:
		for elem in list:
			self.dict[elem]=true
	else:
		self.dict={}
		
func add(elem):
	self.dict[elem]=true
	
func union(set1:Set,set2:Set):
	var res={}
	for elem in set1.dict:
		res[elem]=true
	for elem in set2.dict:
		res[elem]=true
	return Set.new(res)
