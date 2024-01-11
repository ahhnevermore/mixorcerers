class_name  Set
var dict={}
var index
func _init(list):
	self.dict={}
	if list.size()>0:
		for elem in list:
			self.dict[elem]=true
	
func add(elem):
	self.dict[elem]=true
	
func union(set2:Set):
	var res={}
	for elem in self.dict:
		res[elem]=true
	for elem in set2.dict:
		res[elem]=true
	return Set.new(res)

func _iter_init(arg):
	index = 0
	return index < dict.keys().size()

func _iter_next(arg):
	index +=1
	return index < dict.keys().size()

func _iter_get(arg):
	return dict.keys()[index]
