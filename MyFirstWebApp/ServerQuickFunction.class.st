Class {
	#name : #ServerQuickFunction,
	#superclass : #Object,
	#category : #MyFirstWebApp
}

{ #category : #public }
ServerQuickFunction >> perform: action port: aPort [
	action = 'start' ifTrue: [ 
			aPort ifNil:  [ self error: 'What port should I start on?' ].
			ZnServer startDefaultOn: aPort.
			ZnServer default debugMode: true.
			ZnServer default logToTranscript. 
			ZnServer default delegate map: #image to: MyFirstWebApp new.
			^ self
		 ].
	action = 'stop' ifTrue: [ 
			ZnServer stopDefault.
			^ self
		 ].
	self error: 'Unknown action: ', action.
]

{ #category : #registering }
ServerQuickFunction >> stopAll [
"TODO still need to figure out how to use pharo. I'm having trouble wrapping my head around it."
	ZnServer stopDefault .
]
