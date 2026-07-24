"
This class represents a specific type of difference where a relation to another entity has been modified.

The expected value is the target entity or collection from the original model.
The actual value is the new target entity or collection from the modified model.
"
Class {
	#name : 'FSDRelationChanged',
	#superclass : 'FSDPropertyRelatedChange',
	#category : 'Famix-Simple-Diff',
	#package : 'Famix-Simple-Diff'
}

{ #category : 'instance creation' }
FSDRelationChanged class >> createDifference: aRelationName entity: anEntity expectedValue: expectedValue actualValue: actualValue [
	"create a relation change difference"

	^ self new
		  propertyName: aRelationName;
		  entity: anEntity;
		  expectedValue: expectedValue;
		  actualValue: actualValue;
		  yourself
]

{ #category : 'accessing' }
FSDRelationChanged >> changeTypeName [
	^ 'Relation Changed'
]
