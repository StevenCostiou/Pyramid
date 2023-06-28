Class {
	#name : #PyramidTreePresenter,
	#superclass : #SpPresenter,
	#traits : 'TPyramidProjectModelObserver + TPyramidPipelineObserver',
	#classTraits : 'TPyramidProjectModelObserver classTrait + TPyramidPipelineObserver classTrait',
	#instVars : [
		'treePresenter',
		'shouldUpdateSelection',
		'editor'
	],
	#category : #'Pyramid-Bloc-plugin-hierarchy'
}

{ #category : #accessing }
PyramidTreePresenter >> columns [

	^ { PyramidTreeColumn nameAndType }
]

{ #category : #accessing }
PyramidTreePresenter >> connectOn: aPyramidEditor [

	self editor: aPyramidEditor.
	aPyramidEditor activeProject addObserver: self.
	aPyramidEditor commandPipeline addObserver: self
]

{ #category : #api }
PyramidTreePresenter >> contextMenu [

	| menu |
	menu := SpMenuPresenter new.
	self contextMenuGroups do: [ :each | menu addGroup: each ].
	^ menu
]

{ #category : #api }
PyramidTreePresenter >> contextMenuGroups [

	^ {
		  (PyramidTreeMenuGroup browseAndInspect: self).
		  (PyramidTreeMenuGroup addNewElement: self).
		  (PyramidTreeMenuGroup removeElement: self) }
]

{ #category : #layout }
PyramidTreePresenter >> defaultLayout [

	^ SpBoxLayout newVertical add: self treePresenter; yourself
]

{ #category : #accessing }
PyramidTreePresenter >> editor [

	^ editor
]

{ #category : #accessing }
PyramidTreePresenter >> editor: anObject [

	editor := anObject.
	self updateRoots
]

{ #category : #initialization }
PyramidTreePresenter >> initializePresenters [

	shouldUpdateSelection := true.

	treePresenter := SpTreeTablePresenter new.
	treePresenter whenSelectionChangedDo: [ :newSelection |
		self treeSelectionChanged: newSelection ].

	treePresenter
		beMultipleSelection;
		beResizable;
		roots: {  };
		children: [ :each | each children ];
		contextMenu: [ self contextMenu ];
		expandRoots.

	self columns do: [ :each | treePresenter addColumn: each ]
]

{ #category : #'as yet unclassified' }
PyramidTreePresenter >> pyramidPipelineExecuteCommand [

	self updateRoots
]

{ #category : #'as yet unclassified' }
PyramidTreePresenter >> pyramidRootsChanged [

	self updateRoots
]

{ #category : #'as yet unclassified' }
PyramidTreePresenter >> pyramidSelectionChanged [

	self updateSelection
]

{ #category : #accessing }
PyramidTreePresenter >> shouldUpdateSelection [
	^ shouldUpdateSelection
]

{ #category : #accessing }
PyramidTreePresenter >> shouldUpdateSelection: aBoolean [

	shouldUpdateSelection := aBoolean
]

{ #category : #accessing }
PyramidTreePresenter >> treePresenter [

	^ treePresenter
]

{ #category : #'as yet unclassified' }
PyramidTreePresenter >> treeSelectionChanged: aCollection [

	self editor ifNil: [ ^ self ].
	self shouldUpdateSelection ifFalse: [ ^ self ].
	self shouldUpdateSelection: false.
	self editor activeProject selection replaceAll: aCollection selectedItems.
	self shouldUpdateSelection: true
]

{ #category : #accessing }
PyramidTreePresenter >> updateRoots [

	self shouldUpdateSelection: false.
	self treePresenter roots: self editor activeProject roots asArray.
	self shouldUpdateSelection: true.
	self updateSelection
]

{ #category : #'as yet unclassified' }
PyramidTreePresenter >> updateSelection [

	self editor activeProject ifNil: [ ^ self ].
	self shouldUpdateSelection ifFalse: [ ^ self ].
	self shouldUpdateSelection: false.
	self editor activeProject selection
		ifEmpty: [ self treePresenter unselectAll ]
		ifNotEmpty: [
		self treePresenter selectItems: self editor activeProject selection ].
	self shouldUpdateSelection: true
]