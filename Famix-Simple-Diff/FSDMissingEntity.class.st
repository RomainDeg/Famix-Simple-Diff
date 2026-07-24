"
This class implement the Null Object pattern for FamixSimpleDifference values.
 
This class is used when a difference does not have an expected or actual value (expected value of an addition is nil for example). 

We use Null Pattern to avoid useless if cases, and to represent our entities that are missing between models.
"
Class {
	#name : 'FSDMissingEntity',
	#superclass : 'FamixSimpleDifference',
	#category : 'Famix-Simple-Diff',
	#package : 'Famix-Simple-Diff'
}

{ #category : 'accessing' }
FSDMissingEntity >> mooseName [
	^ 'Missing Entity'
]

{ #category : 'accessing' }
FSDMissingEntity >> name [
	^ 'Missing Entity'
]

{ #category : 'printing' }
FSDMissingEntity >> printOn: aStream [
	aStream nextPutAll: 'Missing Entity' 
]
