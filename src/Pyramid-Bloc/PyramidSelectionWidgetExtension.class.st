Class {
	#name : #PyramidSelectionWidgetExtension,
	#superclass : #Object,
	#traits : 'TPyramidSpaceExtension + TPyramidEditorExtension + TPyramidProjectModelObserver + TPyramidEditorTransformationObserver',
	#classTraits : 'TPyramidSpaceExtension classTrait + TPyramidEditorExtension classTrait + TPyramidProjectModelObserver classTrait + TPyramidEditorTransformationObserver classTrait',
	#instVars : [
		'projectModel',
		'widgetElement',
		'commandExecutor',
		'isDragging',
		'dragOrigin'
	],
	#category : #'Pyramid-Bloc-plugin-space-extensions'
}

{ #category : #'as yet unclassified' }
PyramidSelectionWidgetExtension >> alphaFactor [

	^ 0.5
]

{ #category : #'as yet unclassified' }
PyramidSelectionWidgetExtension >> centerDragEnd: anEvent [

	anEvent consumed: true.
	self isDragging: false.
	self usePositionOffsetCommand: anEvent position - self dragOrigin.
	self widgetElement transformDo: [ :t | t translateBy: 0 @ 0 ].
	self widgetElement childrenDo: [ :child |
		child
			childNamed: #drag_ghost
			ifFound: [ :ghost | ghost visibility: BlVisibility hidden ] ]
]

{ #category : #'as yet unclassified' }
PyramidSelectionWidgetExtension >> centerDragEvent: anEvent [

	self isDragging ifFalse: [ ^ self ].
	anEvent primaryButtonPressed ifFalse: [
		self centerDragEnd: anEvent.
		^ self ].
	self widgetElement transformDo: [ :t |
		t translateBy: anEvent position - self dragOrigin ].
	anEvent consumed: true
]

{ #category : #'as yet unclassified' }
PyramidSelectionWidgetExtension >> centerDragStart: anEvent [

	self isDragging: true.
	self dragOrigin: anEvent position.
	anEvent consumed: true.
	self widgetElement childrenDo: [ :child | child childNamed: #drag_ghost ifFound: [ :ghost | ghost visibility: BlVisibility visible ] ]
]

{ #category : #accessing }
PyramidSelectionWidgetExtension >> commandExecutor [

	^ commandExecutor
]

{ #category : #accessing }
PyramidSelectionWidgetExtension >> commandExecutor: anObject [

	commandExecutor := anObject
]

{ #category : #accessing }
PyramidSelectionWidgetExtension >> dragOrigin [

	^ dragOrigin
]

{ #category : #accessing }
PyramidSelectionWidgetExtension >> dragOrigin: anObject [

	dragOrigin := anObject
]

{ #category : #accessing }
PyramidSelectionWidgetExtension >> editor: aPyramidEditor [

	self commandExecutor: aPyramidEditor propertiesManager commandExecutor
]

{ #category : #events }
PyramidSelectionWidgetExtension >> informTransformationChanged [

	self widgetElement position: self currentTransformTranslation  
]

{ #category : #initialization }
PyramidSelectionWidgetExtension >> initialize [

	widgetElement := BlElement new
		                 clipChildren: false;
		                 zIndex: 1;
		                 yourself.
	dragOrigin := 0 @ 0.
	isDragging := false
]

{ #category : #displaying }
PyramidSelectionWidgetExtension >> installOn: aBuilder [

	self builder: aBuilder.
	aBuilder addTransformationObserver: self.
	self elementAtWidgets addChild: self widgetElement
]

{ #category : #accessing }
PyramidSelectionWidgetExtension >> isDragging [

	^ isDragging
]

{ #category : #accessing }
PyramidSelectionWidgetExtension >> isDragging: anObject [

	isDragging := anObject
]

{ #category : #'selection element' }
PyramidSelectionWidgetExtension >> makeMonoSelectionFor: aBlElement [

	| monoSelection eventElement dragGhostElement borderElement |
	monoSelection := (BlOverlayElement on: aBlElement).
	monoSelection clipChildren: false.

	dragGhostElement := BlElement new
		                    id: #drag_ghost;
		                    visibility: BlVisibility hidden;
		                    background:
			                    (aBlElement exportAsForm dimmed: 0.5);
		                    constraintsDo: [ :c |
			                    c vertical matchParent.
			                    c horizontal matchParent ];
		                    yourself.
	eventElement := BlElement new
		                id: #drag_event;
		                constraintsDo: [ :c |
			                c vertical matchParent.
			                c horizontal matchParent ];
		                zIndex: 100;
		                when: BlPrimaryMouseDownEvent
		                do: [ :evt | self centerDragStart: evt ];
		                when: BlMouseEvent
		                do: [ :evt | self centerDragEvent: evt ];
		                when: BlPrimaryMouseUpEvent
		                do: [ :evt | self centerDragEnd: evt ];
		                yourself.
	borderElement := PyramidSelectionWidgetBorderBuilder new build.

	monoSelection addChild: dragGhostElement.
	monoSelection addChild: borderElement.
	monoSelection addChild: eventElement.
	^ monoSelection
]

{ #category : #selection }
PyramidSelectionWidgetExtension >> makeNewSelection [

	| nb |
	nb := 0.
	self projectModel selection do: [ :each | | overlayElement |
		nb := nb + 1.
		overlayElement := self makeMonoSelectionFor: each.
		overlayElement id: ('overlay', nb asString) asSymbol.
		self widgetElement addChild: overlayElement. 
	]
]

{ #category : #'as yet unclassified' }
PyramidSelectionWidgetExtension >> offset [
	^ 10
]

{ #category : #accessing }
PyramidSelectionWidgetExtension >> projectModel [

	^ projectModel
]

{ #category : #accessing }
PyramidSelectionWidgetExtension >> projectModel: aProjectModel [

	projectModel := aProjectModel.
	projectModel addObserver: self.
	self makeNewSelection.
]

{ #category : #events }
PyramidSelectionWidgetExtension >> pyramidElementsChanged [

	self removeSelection.
	self makeNewSelection
]

{ #category : #events }
PyramidSelectionWidgetExtension >> pyramidSelectionChanged [

	self removeSelection.
	self makeNewSelection
]

{ #category : #'selection element' }
PyramidSelectionWidgetExtension >> removeMonoSelections: aBlElementSelectionDecoration [

	"get all BlOverlayElement"
	aBlElementSelectionDecoration childrenDo:[ :c |
		('#overlay*' match: (c id asString)) ifTrue:[
			c detach.
		].
	].
	
	
]

{ #category : #selection }
PyramidSelectionWidgetExtension >> removeSelection [

	(self widgetElement childrenCount > 0) ifFalse:[ ^ self ].

	self removeMonoSelections: self widgetElement.
	self widgetElement removeChildren.
]

{ #category : #'as yet unclassified' }
PyramidSelectionWidgetExtension >> usePositionOffsetCommand: aPosition [

	self commandExecutor
		use: PyramidPositionOffsetCommand new
		on: (PyramidElementsManipulationHelper onlyParents: self projectModel selection asArray)
		with: aPosition
]

{ #category : #accessing }
PyramidSelectionWidgetExtension >> widgetElement [

	^ widgetElement
]
