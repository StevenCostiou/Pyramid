Class {
	#name : #PyramidSelectionMakerController,
	#superclass : #Object,
	#classTraits : 'TPyramidProjectModelObserver classTrait',
	#instVars : [
		'activeProject',
		'overlay',
		'dragOrigin',
		'isDragging',
		'elementPreview',
		'keyboardPressed',
		'selectionStrategy'
	],
	#category : #'Pyramid-Bloc-plugin-space'
}

{ #category : #accessing }
PyramidSelectionMakerController >> activeProject [

	^ activeProject
]

{ #category : #accessing }
PyramidSelectionMakerController >> activeProject: anObject [

	activeProject := anObject.
]

{ #category : #adding }
PyramidSelectionMakerController >> addEventsTo: aBlElement [


	aBlElement when: BlDoubleClickEvent do: [ :evt | self doubleClickEvent: evt ].
	aBlElement when: BlMouseDownEvent do: [ :evt |
		evt primaryButtonPressed ifTrue: [
			self isDragging: true.
			self dragOrigin: evt position.
			self startDragEvent ] ].
	aBlElement
		when: BlMouseMoveEvent
		do: [ :evt |
		self isDragging ifTrue: [ self dragEvent: evt position ] ].
	aBlElement when: BlMouseUpEvent do: [ :evt |
		evt primaryButtonPressed ifTrue: [
			self isDragging: false.
			self endDragEvent ] ]
]

{ #category : #'as yet unclassified' }
PyramidSelectionMakerController >> computeNewSelection: aCollection [

	self computeStrategy.

	self selectionStrategy
		changeSelection: self activeProject selection
		with: aCollection
]

{ #category : #'as yet unclassified' }
PyramidSelectionMakerController >> computeNewSelectionForPosition: aPosition [

	| allElements selectedElements last |
	self activeProject ifNil: [ ^ self ].
	allElements := PyramidTreeToFlat flattenChildrenOfCollection:
		               self activeProject roots.

	selectedElements := allElements select: [ :each |
		                    each boundsInSpace containsPoint: aPosition ].
	selectedElements ifEmpty: [ self computeNewSelection: { }. ^ self ].
	last := selectedElements last.
	self computeNewSelection: { last }
]

{ #category : #'as yet unclassified' }
PyramidSelectionMakerController >> computeNewSelectionInBounds: aBound [

	| allElements selectedElements |
	self activeProject ifNil: [ ^ self ].
	allElements := PyramidTreeToFlat flattenChildrenOfCollection:
		               self activeProject roots.

	selectedElements := allElements select: [ :each |
		                    aBound containsRect: each boundsInSpace ].

	self computeNewSelection: selectedElements.
]

{ #category : #'as yet unclassified' }
PyramidSelectionMakerController >> computeStrategy [


	self keyboardPressed
			  ifEmpty: [
				  self selectionStrategy:
					  PyramidSelectionMakerNoKeyStrategy new. ^ self ].
			  
				  (self keyboardPressed allSatisfy: [ :key | key isShift ])
					  ifTrue: [
						  self selectionStrategy:
							  PyramidSelectionMakerShiftKeyStrategy new. ^ self ].
					 
						  (self keyboardPressed allSatisfy: [ :key |
							   key = key class controlLeft or: [
								   key = key class controlRight ] ])
							  ifTrue: [
								  self selectionStrategy:
									  PyramidSelectionMakerCtrlKeyStrategy new. ^ self ].

								  self selectionStrategy:
									  PyramidSelectionMakerDoNothingStrategy new 
]

{ #category : #'as yet unclassified' }
PyramidSelectionMakerController >> doubleClickEvent: anEvent [

	self computeNewSelectionForPosition: anEvent position.
]

{ #category : #'as yet unclassified' }
PyramidSelectionMakerController >> dragEvent: aPosition [

	| xmin ymin |
	xmin := self dragOrigin x min: aPosition x.
	ymin := self dragOrigin y min: aPosition y.
	self elementPreview position: xmin @ ymin; size: (aPosition - self dragOrigin) abs.
]

{ #category : #accessing }
PyramidSelectionMakerController >> dragOrigin [

	^ dragOrigin
]

{ #category : #accessing }
PyramidSelectionMakerController >> dragOrigin: anObject [

	dragOrigin := anObject
]

{ #category : #accessing }
PyramidSelectionMakerController >> elementPreview [

	^ elementPreview
]

{ #category : #'as yet unclassified' }
PyramidSelectionMakerController >> endDragEvent [

	self elementPreview
		visibility: BlVisibility gone.
	self computeNewSelectionInBounds: self elementPreview boundsInSpace.
]

{ #category : #initialization }
PyramidSelectionMakerController >> initialize [

	dragOrigin := 0 @ 0.
	isDragging := false.
	elementPreview := BlElement new
		                  visibility: BlVisibility gone;
		                  background: Color blue translucent;
		                  zIndex: 200;
		                  yourself.
	selectionStrategy := PyramidSelectionMakerNoKeyStrategy new.
]

{ #category : #accessing }
PyramidSelectionMakerController >> isDragging [

	^ isDragging
]

{ #category : #accessing }
PyramidSelectionMakerController >> isDragging: anObject [

	isDragging := anObject
]

{ #category : #accessing }
PyramidSelectionMakerController >> keyboardPressed [

	^ keyboardPressed
]

{ #category : #accessing }
PyramidSelectionMakerController >> keyboardPressed: anObject [

	keyboardPressed := anObject
]

{ #category : #accessing }
PyramidSelectionMakerController >> overlay [

	^ overlay
]

{ #category : #accessing }
PyramidSelectionMakerController >> overlay: anObject [

	overlay := anObject.
	anObject overlayElement addChild: self elementPreview.
	self addEventsTo: anObject overlayElement.
]

{ #category : #accessing }
PyramidSelectionMakerController >> selectionStrategy [

	^ selectionStrategy
]

{ #category : #accessing }
PyramidSelectionMakerController >> selectionStrategy: anObject [

	selectionStrategy := anObject
]

{ #category : #'as yet unclassified' }
PyramidSelectionMakerController >> startDragEvent [

	self elementPreview
		position: self dragOrigin;
		size: 0 @ 0;
		visibility: BlVisibility visible
]