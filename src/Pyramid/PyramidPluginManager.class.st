Class {
	#name : #PyramidPluginManager,
	#superclass : #Object,
	#instVars : [
		'pluginClasses'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Pyramid-core'
}

{ #category : #initialization }
PyramidPluginManager class >> initialize [

	uniqueInstance := self basicNew initialize.
]

{ #category : #'instance creation' }
PyramidPluginManager class >> new [

	Error signal: 'Use uniqueInstance instead.'
]

{ #category : #initialization }
PyramidPluginManager class >> reset [
	"Use this script to initiliaze each class implementing the trait TPyramidPlugin."

	<script>
	self initialize.
	TPyramidPlugin users do: [ :each | each initialize ]
]

{ #category : #'instance creation' }
PyramidPluginManager class >> uniqueInstance [

	uniqueInstance ifNil: [ self initialize ].
	^ uniqueInstance
]

{ #category : #adding }
PyramidPluginManager >> addPlugin: aPluginClass [

	self pluginClasses add: aPluginClass
]

{ #category : #initialization }
PyramidPluginManager >> initialize [

	pluginClasses := Set new
]

{ #category : #adding }
PyramidPluginManager >> isPluginInstalled: aPluginClass [

	^ self pluginClasses includes: aPluginClass
]

{ #category : #'as yet unclassified' }
PyramidPluginManager >> makeEditor [

	^ PyramidEditorBuilder new
		  plugins: (self pluginClasses collect: [ :class | class new ]);
		  build
]

{ #category : #'as yet unclassified' }
PyramidPluginManager >> pluginClasses [

	^ pluginClasses
]

{ #category : #adding }
PyramidPluginManager >> removePlugin: aPluginClass [

	self pluginClasses remove: aPluginClass ifAbsent: [  ]
]
