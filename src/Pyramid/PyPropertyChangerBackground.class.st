Class {
	#name : #PyPropertyChangerBackground,
	#superclass : #Object,
	#traits : 'TPyPropertyChanger',
	#classTraits : 'TPyPropertyChanger classTrait',
	#category : #'Pyramid-Editor-Properties-Changer'
}

{ #category : #'as yet unclassified' }
PyPropertyChangerBackground >> commandClass [

	^ PyCommandBackground
]

{ #category : #'as yet unclassified' }
PyPropertyChangerBackground >> mutliFormClass [

	^ PyFormColor 
]

{ #category : #accessing }
PyPropertyChangerBackground >> order [

	^ 10
]

{ #category : #'as yet unclassified' }
PyPropertyChangerBackground >> sectionName [

	^ 'Background'
]

{ #category : #'as yet unclassified' }
PyPropertyChangerBackground >> singleFormClass [

	^ PyFormColor
]