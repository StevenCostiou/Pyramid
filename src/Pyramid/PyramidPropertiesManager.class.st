Class {
	#name : #PyramidPropertiesManager,
	#superclass : #Object,
	#instVars : [
		'properties',
		'commandExecutor',
		'presenterStrategy',
		'history'
	],
	#category : #'Pyramid-property'
}

{ #category : #adding }
PyramidPropertiesManager >> addProperty: aPyramidProperty [

	aPyramidProperty commandExecutor: self commandExecutor.
	self properties add: aPyramidProperty
]

{ #category : #'as yet unclassified' }
PyramidPropertiesManager >> buildPresenterFromCollection: aCollection [

	^ self presenterStrategy buildPresenterFromCollection: aCollection andManager: self
]

{ #category : #accessing }
PyramidPropertiesManager >> commandExecutor [

	^ commandExecutor
]

{ #category : #accessing }
PyramidPropertiesManager >> commandExecutor: anObject [

	commandExecutor := anObject.
	self properties do: [ :each | each commandExecutor: anObject ]
]

{ #category : #accessing }
PyramidPropertiesManager >> history [

	^ history
]

{ #category : #initialization }
PyramidPropertiesManager >> initialize [

	properties := OrderedCollection new.
	history := PyramidHistory new.
	commandExecutor := PyramidHistoryCommandExecutor new
		                   history: history;
		                   wrappee: PyramidMainCommandExecutor new;
		                   yourself.

	presenterStrategy := PyramidHideEmptyPropertyStrategy new
]

{ #category : #accessing }
PyramidPropertiesManager >> presenterStrategy [

	^ presenterStrategy
]

{ #category : #accessing }
PyramidPropertiesManager >> presenterStrategy: anObject [

	presenterStrategy := anObject.
]

{ #category : #accessing }
PyramidPropertiesManager >> properties [

	^ properties
]
