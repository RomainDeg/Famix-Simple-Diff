"
This class represents a specific type of difference where an entity has been removed from the target model.

The expected value is the deleted entity.
The actual value is a NullValue.
"
Class {
	#name : 'FSDEntityDeletion',
	#superclass : 'FamixSimpleDifference',
	#category : 'Famix-Simple-Diff',
	#package : 'Famix-Simple-Diff'
}

{ #category : 'instance creation' }
FSDEntityDeletion class >> createDifference: anEntity expectedValue: expectedValue [
	"create a deletion difference"

	^ self new
		  entity: anEntity;
		  expectedValue: expectedValue;
		  actualValue: FSDMissingEntity new;
		  yourself
]

{ #category : 'accessing' }
FSDEntityDeletion >> changeTypeName [
	^ 'Entity Deletion'
]

{ #category : 'printing' }
FSDEntityDeletion >> printValuesOn: aStream [
    aStream nextPutAll: ' | Deleted: '.
    aStream print: self expectedValue.
]
