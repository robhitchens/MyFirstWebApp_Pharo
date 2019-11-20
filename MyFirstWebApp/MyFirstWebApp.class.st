"
I am a simple deployable webapp

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	image:		<Object>


    Implementation Points
"
Class {
	#name : #MyFirstWebApp,
	#superclass : #Object,
	#instVars : [
		'image'
	],
	#category : #MyFirstWebApp
}

{ #category : #public }
MyFirstWebApp >> downloadPharoLogo [ 
	^ ZnClient new 
	beOneShot ;
	get: 'http://www.pharo.org/files/pharo.png';
	entity
]

{ #category : #accessing }
MyFirstWebApp >> form [
	^ self formForImageEntity: self image
]

{ #category : #accessing }
MyFirstWebApp >> formForImageEntity: imageEntity [
	| imageType parserClassName parserClass parser |
	imageType := imageEntity contentType sub.
	parserClassName := imageType asUppercase , #ReadWriter.
	parserClass := Smalltalk globals at: parserClassName asSymbol.
	parser := parserClass on: imageEntity readStream.
	^ parser nextImage
]

{ #category : #public }
MyFirstWebApp >> handleGetRequest: request [ 
^ (request uri queryAt: #raw ifAbsent: [ nil ])
	ifNil: [ ZnResponse ok: (ZnEntity html: self html) ]
	ifNotNil: [ ZnResponse ok: self image ]
]

{ #category : #public }
MyFirstWebApp >> handlePostRequest: request [
	| part newImage badRequest |
	badRequest := [ ^ ZnResponse badRequest: request ].
	(request hasEntity
		and: [ request contentType matches: ZnMimeType multiPartFormData ])
		ifFalse: badRequest.
	part := request entity partNamed: #file ifNone: badRequest.
	newImage := part entity.
	(newImage notNil
		and: [ newImage contentType matches: 'image/*' asZnMimeType ])
		ifFalse: badRequest.
	[ self formForImageEntity: newImage ]
		on: Error
		do: badRequest.
	image := newImage.
	^ ZnResponse redirect: #image
]

{ #category : #public }
MyFirstWebApp >> handleRequest: request [ 
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
	request uri path = #image 
	ifTrue: [ 
		request method = #GET
			ifTrue: [ ^ self handleGetRequest: request ].
		request method = #POST
			ifTrue: [ ^ self handlePostRequest: request ]
		 ].
	^ ZnResponse notFound: request uri 

]

{ #category : #public }
MyFirstWebApp >> html [ 
	^ '<html>
		<head><title>Image</title></head>
		<body>
			<h1>Image</h1>
			<img src="image?raw=true"/>
			<br/>
			<form enctype="multipart/form-data" action="image" method="POST">
				<h3>Change the image:</h3>
				<input type="file" name="file"/>
				<input type="submit" value="Upload"/>
			</form>
		</body>
	</html>'
]

{ #category : #accessing }
MyFirstWebApp >> image [ 
^ image ifNil: [ image := self downloadPharoLogo ]
]

{ #category : #public }
MyFirstWebApp >> value: request [ 
	^ self handleRequest: request 
]
