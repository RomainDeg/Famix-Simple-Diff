"
This class represents a specific type of difference where a new entity has been added to the target model.

The expected value is a NullValue (as the entity did not exist before).
The actual value is the added entity.
"
Class {
	#name : 'FSDEntityAddition',
	#superclass : 'FamixSimpleDifference',
	#category : 'Famix-Simple-Diff',
	#package : 'Famix-Simple-Diff'
}

{ #category : 'instance creation' }
FSDEntityAddition class >> createDifference: anEntity actualValue: actualValue [
	"create an addition"

	^ self new
		  entity: anEntity;
		  expectedValue: FSDMissingEntity new;
		  actualValue: actualValue;
		  yourself
]

{ #category : 'accessing' }
FSDEntityAddition >> changeTypeName [
	^ 'Entity Addition'
]

{ #category : 'printing' }
FSDEntityAddition >> printValuesOn: aStream [
    aStream nextPutAll: ' | Added: '.
    aStream print: self actualValue.
]
