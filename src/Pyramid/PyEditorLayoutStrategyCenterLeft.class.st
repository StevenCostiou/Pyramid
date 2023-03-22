"
I represente the layout of Pyramid with the top bar, the center panel visible and the left panel.
"
Class {
	#name : #PyEditorLayoutStrategyCenterLeft,
	#superclass : #PyEditorLayoutStrategy,
	#category : #'Pyramid-Editor'
}

{ #category : #accessing }
PyEditorLayoutStrategyCenterLeft >> layout [

	| mainPanel |
	mainPanel := SpPanedLayout newLeftToRight
		             positionOfSlider: 0.2;
		             add: self panelLeft;
		             add: self panelCenter;
		             yourself.

	^ SpBoxLayout newTopToBottom
		  add: self panelTop
		  withConstraints: [ :c | c height: PyNavigationAbstract height ];
		  add: mainPanel withConstraints: [ :c | c fill: true ];
		  yourself
]