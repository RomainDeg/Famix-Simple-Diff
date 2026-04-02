Class {
	#name : 'FamixSimpleDiff',
	#superclass : 'Object',
	#instVars : [
		'roots',
		'childrenCache',
		'debug'
	],
	#category : 'Famix-Simple-Diff',
	#package : 'Famix-Simple-Diff'
}

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> compareEntity: aFamixEntity to: otherFamixEntity [

	| properties relations |
	aFamixEntity class = otherFamixEntity class ifFalse: [ ^ self fail ].

	"Comparing properties (slots with non-famix values)"
	properties := aFamixEntity class allSlots select: [ :slot |
		              slot class = FMProperty ].
	properties do: [ :p |
			(p read: aFamixEntity) = (p read: otherFamixEntity) ifFalse: [
				^ self fail ] ].

	"Comparing relations (slots with famix values)"
	relations := aFamixEntity class allSlots select: [ :slot |
		             slot isFMRelationSlot ].
	relations do: [ :r |
			(self compareRelation: r from: aFamixEntity to: otherFamixEntity)
				ifFalse: [ ^ self fail ] ].

	"Every slot value is equal, the entities are identical"
	^ true
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> compareModel: aFamixJavaModel to: aFamixJavaModel2 [

	(self entityRoots: aFamixJavaModel) do: [ :root |
			| correspondingRoot |
			correspondingRoot := self
				                     correspondingEntityTo: root
				                     in: aFamixJavaModel2.
			(self recursiveCompareEntity: root with: correspondingRoot)
				ifFalse: [ ^ self fail ] ].

	^ true
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> compareRelation: aFMRelationSlot from: aFamixEntity to: otherFamixEntity [

	| classesToIgnore val1 val2 sortBlock |
	"just skip those cases"
	classesToIgnore := {
		                   FamixTAnnotationInstance.
		                   FamixTSourceAnchor.
		                   FamixTEntityTyping.
		                   FamixTConcretization }.
	(classesToIgnore includes: aFMRelationSlot targetClass) ifTrue: [
		^ true ].

	aFMRelationSlot isToOne
		ifTrue: [
				val1 := aFMRelationSlot read: aFamixEntity.
				val2 := aFMRelationSlot read: otherFamixEntity ]
		ifFalse: [
				| rejectBlock |
				val1 := (aFMRelationSlot read: aFamixEntity) asOrderedCollection.
				val2 := (aFMRelationSlot read: otherFamixEntity)
					        asOrderedCollection.

				sortBlock := val1
					             ifEmpty: [ self sortBlock ]
					             ifNotEmpty: [ self sortBlockFor: val1 anyOne ].

				rejectBlock := [ :e |
					               | target |
					               e name = 'clone' or: [
							               e class = FamixJavaParametricInvocation or: [
									               (e isInvocation and: [
										                e source class = FamixJavaParametricMethod ])
										               or: [
												               e isAssociation
													               ifTrue: [
															               e target isCollection
																               ifTrue: [ target := e target anyOne ]
																               ifFalse: [ target := e target ] ]
													               ifFalse: [ target := e ].
												               target allContainers anySatisfy: [ :c |
													               c isParametricEntity ] ] ] ] ].

				val1 := val1 reject: rejectBlock.
				val2 := val2 reject: rejectBlock.

				val1 := val1 sorted: sortBlock.
				val2 := val2 sorted: sortBlock ].

	"Sometimes, parent relations are duplicated and are nil.
	This guards for that..."
	val1 == val2 ifTrue: [ ^ true ].

	aFMRelationSlot isToOne
		ifTrue: [ ^ (self pathOfEntity: val1) = (self pathOfEntity: val2) ]
		ifFalse: [ "This is a toMany Relation! and the value should be a collection"
				val1 size = val2 size ifFalse: [ ^ self fail ].
				val1 := val1
					        flatCollect: [ :e | self pathesForMaybeMultiRelation: e ]
					        as: Bag.
				val2 := val2
					        flatCollect: [ :e | self pathesForMaybeMultiRelation: e ]
					        as: Bag.

				val1 = val2 ifFalse: [ ^ self fail ] ifTrue: [ ^ true ] ]
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> computePathOfEntity: anEntity [
	"We only work for single parent entities... And we hope this is the case always.
	If not, talk to Guille, he has a point.
	Read about lexical definition"

	self assert: anEntity containers asSet size <= 1.
	
	"If we have a container, we continue recursively"
	anEntity containers asSet do: [ :c |
			^ (self pathOfEntity: c) copyWith:
				  ((self sortedChildren: c) indexOf: anEntity) ].

	"We don't have a container, this is the root. Return the index of this entity in the root collection"
	^ { ((self entityRoots: anEntity mooseModel) indexOf: anEntity) }
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> correspondingEntityTo: entity in: model [

	| path |
	path := self pathOfEntity: entity.
	^ self entityAtPath: path inModel: model
	
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> debugOn [

	debug := true
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> entityAtPath: indexPath fromEntity: entity [

	indexPath ifEmpty: [ ^ entity ].

	^ self
		  entityAtPath: indexPath allButFirst
		  fromEntity: ((self sortedChildren: entity) at: indexPath first)
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> entityAtPath: indexPath inModel: model [

	| rootEntity |
	rootEntity := (self entityRoots: model) at: indexPath first.
	^ self entityAtPath: indexPath allButFirst fromEntity: rootEntity
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> entityRoots: aFamixJavaModel [

	| goodSortBlock classesToReject |
	classesToReject := {
		                   FamixJavaAnnotationInstance.
		                   FamixJavaAnnotationInstanceAttribute.
		                   FamixJavaWildcard }.

	^ (roots ifNil: [ roots := Dictionary new ])
		  at: aFamixJavaModel
		  ifAbsentPut: [
				  | rootEntities |
				  rootEntities := aFamixJavaModel rootEntities reject: [ :e |
					                  e isStub or: [
						                  classesToReject includes: e class ] ].
				  goodSortBlock := self sortBlockFor: rootEntities anyOne.
				  rootEntities sorted: goodSortBlock ]
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> fail [

	debug ifTrue: [ self halt ].
	^ false
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> initialize [
	
	super initialize.
	debug := false.
	childrenCache := LRUCache new maximumWeight: 100
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> pathOfEntity: anEntity [

	^ anEntity
		  cacheAt: #path
		  ifAbsentPut: [ self computePathOfEntity: anEntity ]
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> pathesForMaybeMultiRelation: multiRelationTargetOrCollectionOrSmellingThing [

	| target targettedEntities |
	target := multiRelationTargetOrCollectionOrSmellingThing isAssociation
		          ifTrue: [ multiRelationTargetOrCollectionOrSmellingThing target ]
		          ifFalse: [ multiRelationTargetOrCollectionOrSmellingThing ].

	targettedEntities := target isCollection
		                     ifTrue: [ target ]
		                     ifFalse: [ { target } ].

	^ targettedEntities collect: [ :e |
		"Please e be an entity please please plz"
		  self pathOfEntity: e ]
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> recursiveCompareEntity: entity1 with: entity2 [

	"Parametric entities and inner classes are not used in the comparison process, so we return true by default"
	entity1 mooseName = entity2 mooseName ifTrue: [
			(entity1 isParametricEntity and: [ entity2 isParametricEntity ])
				ifTrue: [ ^ true ].
			(entity1 isType and: [ entity1 isAnonymousClass ]) ifTrue: [
				^ true ] ].

	"Clone methods have an issue (potentially due to JDT) which isn't easy to fix, so we skip those."
	entity1 name = 'clone' ifTrue: [ ^ true ].

	(self compareEntity: entity1 to: entity2) ifFalse: [ ^ false ].

	(self sortedChildren: entity1)
		with: (self sortedChildren: entity2)
		do: [ :child1 :child2 |
			(self recursiveCompareEntity: child1 with: child2) ifFalse: [
				^ false ] ].

	^ true
]

{ #category : 'sorting' }
FamixSimpleDiff >> sortBlock [

	^ [ :a :b | a mooseName > b mooseName ]
]

{ #category : 'sorting' }
FamixSimpleDiff >> sortBlockFor: anEntity [

	^ anEntity hasUniqueMooseNameInModel
		  ifTrue: [ [ :a :b | a mooseName < b mooseName ] ]
		  ifFalse: [
				  [ :a :b |
					  | valA valB |
					  valA := String streamContents: [ :s | a printOn: s ].
					  valB := String streamContents: [ :s | b printOn: s ].
					  valA < valB ] ]
]

{ #category : 'as yet unclassified' }
FamixSimpleDiff >> sortedChildren: entity [

	| res |
	res := childrenCache at: entity ifAbsentPut: [
			       (entity containedEntities reject: [ :e |
				        e isStub or: [ e name = '<Initializer>' ] ]) sorted: [ :a :b |
					       | valA valB |
					       valA := String streamContents: [ :s | a printOn: s ].
					       valB := String streamContents: [ :s | b printOn: s ].
					       valA = valB
						       ifTrue: [
								       a sourceAnchor
									       ifNotNil: [
											       b sourceAnchor
												       ifNotNil: [ "case for two entities with identical printing string but different source anchor (several inner classes in the same parent for example)"
													       a sourceAnchor endPos < b sourceAnchor endPos ]
												       ifNil: [ valA < valB ] ]
									       ifNil: [ valA < valB] ]
						       ifFalse: [ valA < valB ] ] ].


	^ res
]
