class_name  Set
var dict={}
var index
func _init(list):
	if list.size()>0:
		for elem in list:
			self.add(elem[0])
			
	
func add(elem):
	self.dict[elem]=true
	
func union(set2:Set):
	var res=Set.new([])
	for elem in self.dict:
		res.add(elem)
	for elem in set2.dict:
		res.add(elem)
	return res

func _iter_init(_arg):
	index = 0
	return index < dict.keys().size()

func _iter_next(_arg):
	index +=1
	return index < dict.keys().size()

func _iter_get(_arg):
	return dict.keys()[index]
