Class {
	#name : 'FSDPropertyRelatedChange',
	#superclass : 'FamixSimpleDifference',
	#instVars : [
		'propertyName'
	],
	#category : 'Famix-Simple-Diff',
	#package : 'Famix-Simple-Diff'
}

{ #category : 'accessing' }
FSDPropertyRelatedChange >> changeTypeName [
	^ 'Property Related Change'
]

{ #category : 'printing' }
FSDPropertyRelatedChange >> printPropertyOn: aStream [

	aStream
		nextPutAll: ' | Property: ';
		nextPutAll: self propertyName asString
]

{ #category : 'accessing' }
FSDPropertyRelatedChange >> propertyName [

	^ propertyName
]

{ #category : 'accessing' }
FSDPropertyRelatedChange >> propertyName: anObjet [

	propertyName := anObjet 
]
