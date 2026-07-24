"
This class represents a specific type of difference where a property of an entity has been modified.

The expected value is the property value from the original model.
The actual value is the new property value from the modified model.
"
Class {
	#name : 'FSDPropertyChanged',
	#superclass : 'FSDPropertyRelatedChange',
	#category : 'Famix-Simple-Diff',
	#package : 'Famix-Simple-Diff'
}

{ #category : 'instance creation' }
FSDPropertyChanged class >> createDifference: aPropertyName entity: anEntity expectedValue: expectedValue actualValue: actualValue [
	"create a property change difference"

	^ self new
		  propertyName: aPropertyName;
		  entity: anEntity;
		  expectedValue: expectedValue;
		  actualValue: actualValue;
		  yourself
]

{ #category : 'accessing' }
FSDPropertyChanged >> changeTypeName [
	^ 'Property Changed'
]
