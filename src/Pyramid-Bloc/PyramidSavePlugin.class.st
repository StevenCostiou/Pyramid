Class {
	#name : #PyramidSavePlugin,
	#superclass : #Object,
	#traits : 'TPyramidPlugin',
	#classTraits : 'TPyramidPlugin classTrait',
	#instVars : [
		'inputsController',
		'inputsView',
		'saveModel',
		'inputsButton',
		'savingService',
		'saveButton',
		'projectModel'
	],
	#category : #'Pyramid-Bloc-plugin-save'
}

{ #category : #'class initialization' }
PyramidSavePlugin class >> initialize [

	PyramidPluginManager uniqueInstance addPlugin: self
]

{ #category : #'instance creation' }
PyramidSavePlugin class >> openOn: aCollectionOfBlElement saveModel: aSaveModel [

	| editor savePlugin |
	editor := PyramidEditorBuilder makeEditor.
	savePlugin := editor plugins select: [ :each | each class = self ].
	savePlugin size = 1 ifFalse: [
		Error signal:
			'Wrong installation of SavePlugin. Should only be one instance.' ].
	savePlugin := savePlugin asArray first.
	editor projectModel roots addAll: aCollectionOfBlElement.
	savePlugin openOn: aSaveModel.
	editor window open
]

{ #category : #adding }
PyramidSavePlugin >> addPanelsOn: aPyramidSimpleWindow [

	self inputsController editorWindow: aPyramidSimpleWindow.

	aPyramidSimpleWindow
		at: #topLeft
		addItem: [ :builder |
		builder makeButtonWithIcon: self saveButton order: 1 ].
	aPyramidSimpleWindow
		at: #topLeft
		addItem: [ :builder |
		builder makeButtonWithIcon: self inputsButton order: 2 ]
]

{ #category : #'as yet unclassified' }
PyramidSavePlugin >> connectOn: aPyramidEditor [

	self projectModel: aPyramidEditor projectModel.
	self saveModel projectModel: aPyramidEditor projectModel.
	aPyramidEditor projectModel addObserver: self inputsController
]

{ #category : #initialization }
PyramidSavePlugin >> initialize [

	inputsController := PyramidSaveProjectConfigurationController new.
	inputsView := inputsController view.
	saveModel := inputsController saveModel.

	savingService := PyramidSavingService new
		                 saveModel: saveModel;
		                 methodBuilder: PyramidSavingMethodBuilder ston;
		                 yourself.

	inputsButton := SpButtonPresenter new
		                icon: (self iconNamed: #smallRemoteOpen);
		                help: 'Project configuration';
		                action: [
			                (PyramidPopoverFactory
				                 makeWithPresenter: inputsView
				                 relativeTo: inputsButton
				                 position: SpPopoverPosition right) popup ];
		                yourself.

	saveButton := SpButtonPresenter new
		              icon: (self iconNamed: #smallSave);
		              help: 'Save project';
		              action: [ self saveAction ];
		              yourself
]

{ #category : #accessing }
PyramidSavePlugin >> inputsButton [

	^ inputsButton
]

{ #category : #accessing }
PyramidSavePlugin >> inputsController [

	^ inputsController
]

{ #category : #accessing }
PyramidSavePlugin >> inputsView [

	^ inputsView
]

{ #category : #'instance creation' }
PyramidSavePlugin >> openOn: aSaveModel [
	"self inputsView inputClass text: aSaveModel savingClassName.
	self inputsView inputMethod text: aSaveModel savingMethodName.
	self inputsView inputPackage text: aSaveModel savingPackageName.
	self inputsView model isSaved: aSaveModel isSaved."

	aSaveModel projectModel: self projectModel.
	self savingService saveModel: aSaveModel.
	self inputsController saveModel: aSaveModel.

	aSaveModel isClassSide
		ifTrue: [ self inputsView buttonClass click ]
		ifFalse: [ self inputsView buttonInstance click ]
]

{ #category : #accessing }
PyramidSavePlugin >> projectModel [

	^ projectModel
]

{ #category : #accessing }
PyramidSavePlugin >> projectModel: aPyramidProjectModel [

	projectModel := aPyramidProjectModel.
	self inputsController updateView
]

{ #category : #actions }
PyramidSavePlugin >> saveAction [
	"Action executed by a save button from UI, this method catch exceptions when needed to doesn't expose directly a debugger but an info window"

	[
	self savingService save.
	self inputsController isSaved. 
	]
	on: Error
	do: [ :e |
		
		"Pyramid level error"
		(e isKindOf: PyramidSaveError) ifTrue:[		
			^ UIManager default
				 	alert: 'Cannot save the project, open project configuration to setup a valid saving location.'
			 	 	title: 'Project configuration problem'
		].
		
		"Serializer level error"
		(e isKindOf: BlocSerializationError) ifTrue:[		
			(UIManager default
				confirm: 'Error when saving the project: ', e messageText asString, '
				Debug this error ?'
			 	label: 'Error')
			ifTrue:[e debug] ifFalse:[^ self].
		].
	]
]

{ #category : #accessing }
PyramidSavePlugin >> saveButton [

	^ saveButton
]

{ #category : #accessing }
PyramidSavePlugin >> saveModel [

	^ saveModel
]

{ #category : #accessing }
PyramidSavePlugin >> savingService [

	^ savingService
]
