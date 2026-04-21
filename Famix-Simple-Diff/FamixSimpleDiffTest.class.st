Class {
	#name : 'FamixSimpleDiffTest',
	#superclass : 'TestCase',
	#instVars : [
		'modelResources',
		'mainModel1',
		'mainModel2'
	],
	#category : 'Famix-Simple-Diff',
	#package : 'Famix-Simple-Diff'
}

{ #category : 'running' }
FamixSimpleDiffTest >> setUp [
	super setUp.

	"fix here to limit window's performances problems"
	self timeLimit: 15 seconds.
	"Put here a common initialization logic for tests"
	mainModel1 := TestJavaModelBuilder loadMainModel.
	mainModel2 := TestJavaModelBuilder loadMainModel 
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testClassesWithDifferentNamesAreNotEqual [

	| sd entity1 entity2 |
	sd := FamixSimpleDiff new.
	entity1 := mainModel1 entityNamed: 'some.thing.whatever.MainClass'.
	entity2 := mainModel2 entityNamed: 'some.thing.whatever.MainClass'.
	entity2 name: 'NewName'. 
	
	self assert: (sd compareEntity: entity1 to: entity2) equals: false
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testClassesWithDifferentSuperclassesAreNotEqual [

	| sd entity1 entity2 newInheritance |
	sd := FamixSimpleDiff new.
	entity1 := mainModel1 entityNamed: 'some.thing.whatever.MainClass'.
	entity2 := mainModel2 entityNamed: 'some.thing.whatever.MainClass'.
	
	newInheritance := mainModel2 newInheritance
		superclass: entity2;
		subclass: entity2.
	entity2 superInheritances: { newInheritance }. 
	
	self assert: (sd compareEntity: entity1 to: entity2) equals: false
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testCorrespondingClassesAreEqual [

	| sd entity1 entity2 path |
	sd := FamixSimpleDiff new.
	entity1 := mainModel1 entityNamed: 'some.thing.whatever.MainClass'.
	path := sd pathOfEntity: entity1.
	entity2 := sd entityAtPath: path inModel: mainModel2.
	
	self assert: (sd compareEntity: entity1 to: entity2)
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testCorrespondingClassesInSameModelIsSameEntity [

	| sd entity1 entity2 path |
	sd := FamixSimpleDiff new.
	entity1 := mainModel1 entityNamed: 'some.thing.whatever.MainClass'.
	path := sd pathOfEntity: entity1.
	entity2 := sd entityAtPath: path inModel: mainModel1.
	
	self assert: entity1 == entity2
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testCorrespondingMethodsAreEqual [

	| sd entity1 entity2 path |
	sd := FamixSimpleDiff new.
	
	entity1 := mainModel1 entityNamed: 'some.thing.whatever.MainClass.getIntAttribute()'.
	path := sd pathOfEntity: entity1.
	entity2 := sd entityAtPath: path inModel: mainModel2.
	
	self assert: (sd compareEntity: entity1 to: entity2)
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testCorrespondingMethodsInSameModelIsSameEntity [

	| sd entity1 entity2 path |
	sd := FamixSimpleDiff new.
	entity1 := mainModel1 entityNamed: 'some.thing.whatever.MainClass.getIntAttribute()'.
	path := sd pathOfEntity: entity1.
	entity2 := sd entityAtPath: path inModel: mainModel1.
	
	self assert: entity1 == entity2
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testCorrespondingPrimitiveTypesAreEqual [

	| sd entity1 entity2 path |
	sd := FamixSimpleDiff new.

	entity1 := (mainModel1 entityNamed: 'some.thing.whatever.MainClass.getIntAttribute()') declaredType.
	path := sd pathOfEntity: entity1.
	entity2 := sd entityAtPath: path inModel: mainModel2.
	
	self assert: (sd compareEntity: entity1 to: entity2)
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testEqualClassesAreEqual [

	| sd entity1 |
	sd := FamixSimpleDiff new.
	entity1 := mainModel1 entityNamed: 'some.thing.whatever.MainClass'.
	
	self assert: (sd compareEntity: entity1 to: entity1)
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testEqualMethodsAreEqual [

	| sd entity1 |
	sd := FamixSimpleDiff new.
	entity1 := mainModel1 entityNamed: 'some.thing.whatever.MainClass.getIntAttribute()'.
	
	self assert: (sd compareEntity: entity1 to: entity1)
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testEqualModelsAreEqual [

	| sd |
	sd := FamixSimpleDiff new.
	
	self assert: (sd compareModel: mainModel1 to: mainModel2)
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testMethodsWithDifferentNamesAreNotEqual [

	| sd entity1 entity2 |
	sd := FamixSimpleDiff new.
	entity1 := mainModel1 entityNamed: 'some.thing.whatever.MainClass.getIntAttribute()'.
	entity2 := mainModel2 entityNamed: 'some.thing.whatever.MainClass.getIntAttribute()'.
	entity2 name: 'NewName'. 
	
	self assert: (sd compareEntity: entity1 to: entity2) equals: false
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testSameClassesAreEqual [

	| sd entity1 entity2 |
	sd := FamixSimpleDiff new.
	entity1 := mainModel1 entityNamed: 'some.thing.whatever.MainClass'.
	entity2 := mainModel2 entityNamed: 'some.thing.whatever.MainClass'.
	
	self assert: (sd compareEntity: entity1 to: entity2)
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testSameMethodsAreEqual [

	| sd entity1 entity2 |
	sd := FamixSimpleDiff new.
	entity1 := mainModel1 entityNamed: 'some.thing.whatever.MainClass.getIntAttribute()'.
	entity2 := mainModel2 entityNamed: 'some.thing.whatever.MainClass.getIntAttribute()'.
	
	self assert: (sd compareEntity: entity1 to: entity2)
]

{ #category : 'tests' }
FamixSimpleDiffTest >> testSameModelsAreEqual [

	| sd |
	sd := FamixSimpleDiff new.
	
	self assert: (sd compareModel: mainModel1 to: mainModel1)
]
