Class {
	#name : #PyramidHistoryPlugin,
	#superclass : #Object,
	#traits : 'TPyramidPlugin + TPyramidProjectModelObserver',
	#classTraits : 'TPyramidPlugin classTrait + TPyramidProjectModelObserver classTrait',
	#instVars : [
		'undoButton',
		'redoButton',
		'history',
		'projectModel'
	],
	#category : #'Pyramid-history'
}

{ #category : #'class initialization' }
PyramidHistoryPlugin class >> initialize [

	PyramidPluginManager uniqueInstance addPlugin: self
]

{ #category : #adding }
PyramidHistoryPlugin >> addPanelsOn: aPyramidSimpleWindow [

	aPyramidSimpleWindow
		at: #topCenter
		addItem: [ :builder |
		builder makeButtonWithIcon: self undoButton order: 10 ].
	aPyramidSimpleWindow
		at: #topCenter
		addItem: [ :builder |
		builder makeButtonWithIcon: self redoButton order: 20 ]
]

{ #category : #'as yet unclassified' }
PyramidHistoryPlugin >> connectOn: aPyramidEditor [

	self history: aPyramidEditor propertiesManager history.
	self projectModel: aPyramidEditor projectModel.
	self pyramidSelectionChanged
]

{ #category : #accessing }
PyramidHistoryPlugin >> history [

	^ history
]

{ #category : #accessing }
PyramidHistoryPlugin >> history: anObject [

	history := anObject
]

{ #category : #'as yet unclassified' }
PyramidHistoryPlugin >> initialize [

	undoButton := SpButtonPresenter new
		              icon: (self iconNamed: #smallUndo);
		              action: [
			              self history undo.
			              self projectModel informElementsChanged ];
						 enabled: false;
		              help: 'Undo';
		              yourself.
	redoButton := SpButtonPresenter new
		              icon: (self iconNamed: #smallRedo);
		              action: [
			              self history redo.
			              self projectModel informElementsChanged ];
						 enabled: false;
		              help: 'Redo';
		              yourself
]

{ #category : #accessing }
PyramidHistoryPlugin >> projectModel [

	^ projectModel
]

{ #category : #accessing }
PyramidHistoryPlugin >> projectModel: anObject [

	projectModel := anObject.
	anObject addObserver: self.
]

{ #category : #'as yet unclassified' }
PyramidHistoryPlugin >> pyramidElementsChanged [

	undoButton enabled: self history canUndo.
	redoButton enabled: self history canRedo
]

{ #category : #accessing }
PyramidHistoryPlugin >> redoButton [

	^ redoButton
]

{ #category : #accessing }
PyramidHistoryPlugin >> undoButton [

	^ undoButton
]
