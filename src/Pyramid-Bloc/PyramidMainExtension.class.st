Class {
	#name : #PyramidMainExtension,
	#superclass : #Object,
	#traits : 'TPyramidSpaceExtension + TPyramidEditorExtension + TPyramidProjectModelObserver + TPyramidEditorTransformationObserver',
	#classTraits : 'TPyramidSpaceExtension classTrait + TPyramidEditorExtension classTrait + TPyramidProjectModelObserver classTrait + TPyramidEditorTransformationObserver classTrait',
	#instVars : [
		'containerElement',
		'projectModel',
		'borderElement',
		'sizeElement',
		'extentButton',
		'extentView',
		'extentPopover'
	],
	#category : #'Pyramid-Bloc-plugin-space-extensions'
}

{ #category : #accessing }
PyramidMainExtension >> borderElement [

	^ borderElement
]

{ #category : #accessing }
PyramidMainExtension >> containerElement [

	^ containerElement
]

{ #category : #accessing }
PyramidMainExtension >> defaultBorder [

	^ BlBorder paint: Color blue width: 1
]

{ #category : #accessing }
PyramidMainExtension >> defaultExtent [

	^ 800 @ 600
]

{ #category : #accessing }
PyramidMainExtension >> editor: aPyramidEditor [

	aPyramidEditor window at: #topRight addItem: [ :buttonBuilder |
		buttonBuilder makeButtonWithIcon: self extentButton order: 10 ]
]

{ #category : #geometry }
PyramidMainExtension >> extent: aPoint [

	self elementAtWidgets size: aPoint.
	self sizeElement size: aPoint
]

{ #category : #accessing }
PyramidMainExtension >> extentButton [

	^ extentButton
]

{ #category : #'as yet unclassified' }
PyramidMainExtension >> informTransformationChanged [

	self elementAtEvents transformDo: [ :t |
		t translateBy: self currentTransformTranslation negated ].
]

{ #category : #initialization }
PyramidMainExtension >> initialize [

	extentView := SpPresenter new
		              layout: (SpBoxLayout newVertical
				               spacing: 4;
				               add: (SpLabelPresenter new
						                displayBold: [ true ];
						                label: 'Window extent';
						                yourself);
				               add: (PyramidPointInputPresenter new
						                value: self defaultExtent;
						                whenValueChangedDo: [ :point | self extent: point ];
						                yourself);
				               yourself);
		              yourself.

	extentButton := SpButtonPresenter new
		                icon: (self iconNamed: #window);
		                help: 'Project configuration';
		                action: [ extentPopover popup ];
		                yourself.
	extentPopover := PyramidPopoverFactory
		                 makeWithPresenter: extentView
		                 relativeTo: extentButton
		                 position: SpPopoverPosition left.


	containerElement := BlElement new
		                    constraintsDo: [ :c |
			                    c vertical matchParent.
			                    c horizontal matchParent ];
		                    clipChildren: false;
		                    zIndex: 0;
		                    yourself.
	borderElement := BlElement new
		                 border: self defaultBorder;
		                 outskirts: BlOutskirts outside;
		                 constraintsDo: [ :c |
			                 c vertical matchParent.
			                 c horizontal matchParent ];
		                 clipChildren: false;
		                 zIndex: 1;
		                 yourself.
	sizeElement := BlElement new
		               size: self defaultExtent;
		               clipChildren: false;
		               addChildren: {
				               containerElement.
				               borderElement } yourself
]

{ #category : #displaying }
PyramidMainExtension >> installOn: aBuilder [

	self builder: aBuilder.
	aBuilder addTransformationObserver: self.
	self elementAtMain addChild: self sizeElement.
	self elementAtTransforms transformDo: [ :t |
		t translateBy: self offsetTranslation ].
	self builder signalTransformationChanged.
	self elementAtWidgets size: self defaultExtent
]

{ #category : #'as yet unclassified' }
PyramidMainExtension >> offsetTranslation [

	^ 50 @ 50
]

{ #category : #accessing }
PyramidMainExtension >> projectModel [

	^ projectModel
]

{ #category : #accessing }
PyramidMainExtension >> projectModel: aProjectModel [

	projectModel:= aProjectModel.
	aProjectModel addObserver: self.
]

{ #category : #'as yet unclassified' }
PyramidMainExtension >> pyramidRootsChanged [

	self containerElement removeChildren.
	(self projectModel roots asArray sorted: PyramidElevationSortFunction new) do: [ :each |
		each parent ifNotNil: [ :p | p removeChild: each ].
		self containerElement addChild: each ]
]

{ #category : #accessing }
PyramidMainExtension >> sizeElement [

	^ sizeElement
]
