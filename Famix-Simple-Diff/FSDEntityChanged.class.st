"
This class represents a specific type of difference where two entities changed.

The expected value is the entity from the original model.
The actual value is the entity from the modified model.
"
Class {
	#name : 'FSDEntityChanged',
	#superclass : 'FamixSimpleDifference',
	#category : 'Famix-Simple-Diff',
	#package : 'Famix-Simple-Diff'
}

{ #category : 'instance creation' }
FSDEntityChanged class >> createDifference: anEntity expectedValue: expectedValue actualValue: actualValue [
	"create an entity change difference"

	^ self new
		  entity: anEntity;
		  expectedValue: expectedValue;
		  actualValue: actualValue;
		  yourself
]

{ #category : 'accessing' }
FSDEntityChanged >> changeTypeName [
	^ 'Entity Changed'
]
