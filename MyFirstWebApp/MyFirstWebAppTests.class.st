"
Tests for MyFirstWebApp
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #MyFirstWebAppTests,
	#superclass : #TestCase,
	#category : #MyFirstWebApp
}

{ #category : #accessing }
MyFirstWebAppTests >> image [
	^ ZnClient new
		beOneShot;
		get: 'http://zn.stfx.eu/zn/Hot-Air-Balloon.gif';
		entity
]

{ #category : #tests }
MyFirstWebAppTests >> testDefaultImage [
	"comment stating purpose of instance-side message"

	"scope: class-variables  &  instance-variables"

	self
		withServerDo: [ :server | 
			| client |
			client := ZnClient new.
			client
				url: server localUrl;
				addPath: #image;
				queryAt: #raw put: #true.
			client get.
			self assert: client isSuccess.
			self
				assert: (client entity contentType matches: 'image/*' asZnMimeType).
			self assert: client entity equals: server delegate image.
			client close ]
]

{ #category : #tests }
MyFirstWebAppTests >> testMainPage [
	self
		withServerDo: [ :server | 
			| client |
			client := ZnClient new.
			client
				url: server localUrl;
				addPath: #image.
			client get.
			self assert: client isSuccess.
			self
				assert: (client entity contentType matches: ZnMimeType textHtml).
			self assert: (client contents includesSubstring: 'Image').
			client close ]
]

{ #category : #tests }
MyFirstWebAppTests >> testUpload [
	self
		withServerDo: [ :server | 
			| image client |
			image := self image.
			client := ZnClient new.
			client
				url: server localUrl;
				addPath: #image.
			client addPart: (ZnMimePart fieldName: #file entity: image).
			client post.
			self assert: client isSuccess.
			client
				resetEntity;
				queryAt: #raw put: #true.
			client get.
			self assert: client isSuccess.
			self assert: client entity equals: image.
			client close ]
]

{ #category : #helper }
MyFirstWebAppTests >> withServerDo: block [
	| server |
	server := ZnServer on: 1700 + 10 atRandom.
	[ server start.
	self assert: server isRunning & server isListening.
	server delegate: MyFirstWebApp new.
	block cull: server ]
		ensure: [ server stop ]
]
