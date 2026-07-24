"
This test class contains all the test cases focused on validating the difference objects themselves, and not the algorithms.
"
Class {
	#name : 'FamixSimpleDifferenceTest',
	#superclass : 'TestCase',
	#category : 'Famix-Simple-Diff-Tests',
	#package : 'Famix-Simple-Diff-Tests'
}

{ #category : 'tests' }
FamixSimpleDifferenceTest >> testChangeTypeNameEntityAddition [
	| entityAddition |
	entityAddition := FSDEntityAddition createDifference: 'Entity' actualValue: 'Actual'.
	
	self assert: entityAddition changeTypeName equals: 'Entity Addition'.
]

{ #category : 'tests' }
FamixSimpleDifferenceTest >> testChangeTypeNameEntityChanged [

	| entityChanged |
	entityChanged := FSDEntityChanged
		                 createDifference: 'Entity'
		                 expectedValue: 'Expected'
		                 actualValue: 'Actual'.

	self assert: entityChanged changeTypeName equals: 'Entity Changed'
]

{ #category : 'tests' }
FamixSimpleDifferenceTest >> testChangeTypeNameEntityDeletion [

	| entityDeletion |
	entityDeletion := FSDEntityDeletion
		                  createDifference: 'Entity'
		                  expectedValue: 'Expected'.

	self assert: entityDeletion changeTypeName equals: 'Entity Deletion'
]

{ #category : 'tests' }
FamixSimpleDifferenceTest >> testChangeTypeNamePropertyChanged [

	| propertyChanged |
	propertyChanged := FSDPropertyChanged
		                   createDifference: '#name'
		                   entity: 'Entity'
		                   expectedValue: 'Expected'
		                   actualValue: 'Actual'.
	self
		assert: propertyChanged changeTypeName
		equals: 'Property Changed'
]

{ #category : 'tests' }
FamixSimpleDifferenceTest >> testChangeTypeNameRelationChanged [

	| relationChanged |
	relationChanged := FSDRelationChanged
		                   createDifference: '#name'
		                   entity: 'Entity'
		                   expectedValue: 'Expected'
		                   actualValue: 'Actual'.

	self
		assert: relationChanged changeTypeName
		equals: 'Relation Changed'
]

{ #category : 'tests' }
FamixSimpleDifferenceTest >> testInstanceCreation [
	| difference expectedValue actualValue |
	
	"testing a code modification"
	expectedValue := 'private int money;'.
	actualValue := 'private int age;'.
	difference := FSDEntityChanged
	              createDifference: 'testEntity'
	              expectedValue: expectedValue
	              actualValue: actualValue.
						
	"checking instance creation"
	self assert: difference entity equals: 'testEntity'.
	self assert: difference class equals: FSDEntityChanged.
	self assert: difference expectedValue equals: expectedValue.
	self assert: difference actualValue equals: actualValue.
]

{ #category : 'accessing' }
FamixSimpleDifferenceTest >> testNullValues [
	| nullPattern |
	nullPattern := FSDMissingEntity new.
	
	self assert: nullPattern name equals: 'Missing Entity'. 
	self assert: nullPattern mooseName equals: 'Missing Entity'.
	self assert: nullPattern printString equals: 'Missing Entity'. 
]

{ #category : 'accessing' }
FamixSimpleDifferenceTest >> testPrintOn [

	| additionDiff output expectedString |
	additionDiff := FSDEntityAddition
		                createDifference: Object
		                actualValue: 'Actual'.

	output := additionDiff printString.
	expectedString := '[Entity Addition] On: Object | Added: ''Actual'''.

	"strings should be equals"
	self assert: output equals: expectedString
]

{ #category : 'accessing' }
FamixSimpleDifferenceTest >> testPrintOnWithPropertyName [

	| diff output expectedString |
	diff := FSDPropertyChanged
	        createDifference: 'modifiers'
	        entity: Object
	        expectedValue: 'public'
	        actualValue: 'private'.
	output := diff printString.
	expectedString := '[Property Changed] On: Object | Property: modifiers | Expected: ''public'' | Actual: ''private'''.

	self assert: output equals: expectedString
]
