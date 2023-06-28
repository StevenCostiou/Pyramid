Class {
	#name : #PyramidNoArgTrigger,
	#superclass : #PyramidPropertyInputTrigger,
	#category : #'Pyramid-properties'
}

{ #category : #'as yet unclassified' }
PyramidNoArgTrigger >> argBlock: aCallbackBlock input: input collection: collection model: model [

	^ [ aCallbackBlock value: input value: collection value: model ]
]