class_name  Grid
var dict={}
var index
func _init(list):
	if list.size()>0:
		for elem in list:
			self.add(elem)

func add(elem):
	if elem[0] in self.dict:
		if self.dict[elem[0]][0]>elem[1][0]:
			self.dict[elem[0]]=elem[1]
	else:
		self.dict[elem[0]]=elem[1]

func union(grid2:Grid)->Grid:
	#SAme logic in both for loops, different than add, because the values are needed
	var res=Grid.new([])
	for elem in self.dict:
		if elem in res.dict:
			if res.dict[elem][0] > self.dict[elem][0]:
				res.dict[elem]=self.dict[elem]
		else:
			res.dict[elem]=self.dict[elem]
	for elem in grid2.dict:
		if elem in res.dict:
			if res.dict[elem][0] > grid2.dict[elem][0]:
				res.dict[elem]=grid2.dict[elem]
		else:
			res.dict[elem]=grid2.dict[elem]
	return res

func _iter_init(_arg):
	index = 0
	return index < dict.size()

func _iter_next(_arg):
	index +=1
	return index < dict.size()

func _iter_get(_arg):
	var k=dict.keys()[index]
	return [k,dict[k]]
