'From Cuis 5.0 [latest update: #4034] on 2 February 2020 at 11:38:14 pm'!
'Description '!
!provides: 'TempVarDeclarationNodes' 1 0!
SystemOrganization addCategory: #TempVarDeclarationNodes!


!classDefinition: #TempVarDeclarationNodesCompiler category: #TempVarDeclarationNodes!
Compiler subclass: #TempVarDeclarationNodesCompiler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TempVarDeclarationNodes'!
!classDefinition: 'TempVarDeclarationNodesCompiler class' category: #TempVarDeclarationNodes!
TempVarDeclarationNodesCompiler class
	instanceVariableNames: ''!

!classDefinition: #TempVarDeclarationNodesParser category: #TempVarDeclarationNodes!
Parser subclass: #TempVarDeclarationNodesParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TempVarDeclarationNodes'!
!classDefinition: 'TempVarDeclarationNodesParser class' category: #TempVarDeclarationNodes!
TempVarDeclarationNodesParser class
	instanceVariableNames: ''!

!classDefinition: #TemporariesDeclarationNode category: #TempVarDeclarationNodes!
ParseNode subclass: #TemporariesDeclarationNode
	instanceVariableNames: 'tempDeclarationNodes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TempVarDeclarationNodes'!
!classDefinition: 'TemporariesDeclarationNode class' category: #TempVarDeclarationNodes!
TemporariesDeclarationNode class
	instanceVariableNames: ''!

!classDefinition: #TemporaryDeclarationNode category: #TempVarDeclarationNodes!
ParseNode subclass: #TemporaryDeclarationNode
	instanceVariableNames: 'variableNode'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TempVarDeclarationNodes'!
!classDefinition: 'TemporaryDeclarationNode class' category: #TempVarDeclarationNodes!
TemporaryDeclarationNode class
	instanceVariableNames: ''!

!classDefinition: #Ejemplo category: #TempVarDeclarationNodes!
Object subclass: #Ejemplo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TempVarDeclarationNodes'!
!classDefinition: 'Ejemplo class' category: #TempVarDeclarationNodes!
Ejemplo class
	instanceVariableNames: ''!


!TempVarDeclarationNodesCompiler class methodsFor: 'nil' stamp: 'RNG 1/14/2020 21:57:25'!
parserClass

	^ TempVarDeclarationNodesParser! !

!Ejemplo class methodsFor: 'nil' stamp: 'RNG 1/14/2020 21:57:13'!
compilerClass

	^ TempVarDeclarationNodesCompiler! !

!TempVarDeclarationNodesParser methodsFor: 'nil' stamp: 'RNG 2/2/2020 17:34:36'!
blockExpression
	"[ ({:var} |) (| {temps} |) (statements) ] => BlockNode."

	| blockNode tempsDeclarationNode variableNodes temporaryBlockVariables start |
	blockNode := BlockNode new.
	variableNodes := OrderedCollection new.
	start := prevMark + requestorOffset.
	"Gather parameters."
	[self match: #colon] whileTrue:
		[self argumentNameWithRangeDo: [ :argumentName :range |
			variableNodes addLast: (encoder bindBlockArg: argumentName within: blockNode range: range)]].
	(variableNodes size > 0 & (hereType ~~ #rightBracket) and: [(self match: #verticalBar) not]) ifTrue:
		[^self expected: 'Vertical bar'].

	tempsDeclarationNode _ self temporaryBlockVariablesFor: blockNode.
	temporaryBlockVariables _ tempsDeclarationNode allDeclaredVariableNodes.
	self statements: variableNodes innerBlock: true blockNode: blockNode.
	blockNode temporariesDeclaration: tempsDeclarationNode.

	(self match: #rightBracket) ifFalse: [^self expected: 'Period or right bracket'].

	blockNode noteSourceRangeStart: start end: self endOfLastToken encoder: encoder.

	"The scope of the parameters and temporary block variables is no longer active."
	temporaryBlockVariables do: [:variable | variable scope: -1].
	variableNodes do: [:variable | variable scope: -1]! !

!TempVarDeclarationNodesParser methodsFor: 'nil' stamp: 'RNG 2/2/2020 23:32:16'!
createTempDeclarationOf: variableNode sourceRange: sourceRange

	| declarationNode |
	declarationNode _ TemporaryDeclarationNode of: variableNode.
	encoder noteSourceRange: sourceRange forNode: declarationNode.
	^ declarationNode! !

!TempVarDeclarationNodesParser methodsFor: 'nil' stamp: 'RNG 2/2/2020 23:28:23'!
createTempsDeclarationWith: tempDeclarationNodes sourceRange: sourceRange

	|tempsDeclarationNode|
	tempsDeclarationNode _ TemporariesDeclarationNode withAll: tempDeclarationNodes.
	encoder noteSourceRange: sourceRange forNode: tempsDeclarationNode.
	^ tempsDeclarationNode! !

!TempVarDeclarationNodesParser methodsFor: 'nil' stamp: 'RNG 2/2/2020 17:31:01'!
method: noPattern doIt: doIt context: ctxt 
	" pattern [ | temporaries ] block => MethodNode."

	| sap block primitives tempsDeclarationNode messageComment methodNode |
	
	sap := self pattern: noPattern inContext: ctxt.
	"sap={selector, arguments, precedence}"
	self properties selector: (sap at: 1).
	encoder selector: (sap at: 1).
	(sap at: 2) do: [:argNode | argNode beMethodArg].
	
	doIt ifFalse: [self pragmaSequence].
	tempsDeclarationNode _ self temporaries.
	messageComment := currentComment.
	currentComment := nil.
	doIt ifFalse: [self pragmaSequence].
	primitives := self pragmaPrimitives.
	
	self statements: #() innerBlock: doIt.
	block := parseNode.
	doIt 
		ifTrue: [block returnLast]
		ifFalse: [block returnSelfIfNoOther: encoder].
	hereType == #doIt ifFalse: [^self expected: 'Nothing more'].
	
	methodNode := self newMethodNode comment: messageComment.
	methodNode
		selector: (sap at: 1)
		arguments: (sap at: 2)
		precedence: (sap at: 3)
		temporariesDeclaration: tempsDeclarationNode
		block: block
		encoder: encoder
		primitive: primitives
		properties: properties
		selectorKeywordsRanges: (sap at: 4).
		
	self interactive ifTrue: [ self performInteractiveChecks: methodNode ].
	
	^methodNode! !

!TempVarDeclarationNodesParser methodsFor: 'nil' stamp: 'RNG 2/2/2020 23:33:34'!
noTempsDeclaration

	^ TemporariesDeclarationNode empty! !

!TempVarDeclarationNodesParser methodsFor: 'nil' stamp: 'RNG 2/2/2020 23:33:47'!
temporaries
	" [ '|' (variable)* '|' ]"
	| tempDeclarationNodes theActualText declarationStartIndex |
	(self match: #verticalBar) ifFalse: 
		["no temps"
		doitFlag ifTrue:
			[tempsMark := self interactive
								ifTrue: [requestor selectionInterval first]
								ifFalse: [1].
			^ self noTempsDeclaration ].
		tempsMark := hereMark	"formerly --> prevMark + prevToken".
		tempsMark > 0 ifTrue:
			[theActualText := source contents.
			[tempsMark < theActualText size and: [(theActualText at: tempsMark) isSeparator]]
				whileTrue: [tempsMark := tempsMark + 1]].
			^ self noTempsDeclaration ].
	tempDeclarationNodes _ OrderedCollection new.
	declarationStartIndex _ prevMark.
	[hereType == #word] whileTrue: [
		self advanceWithRangeDo: [ :variableName :range |
			| variableNode |
			variableNode _ encoder bindTemp: variableName range: range.
			tempDeclarationNodes addLast: (self createTempDeclarationOf: variableNode sourceRange: range) ] ].
	(self match: #verticalBar) ifTrue: [
		tempsMark := prevMark.
		^ self
			createTempsDeclarationWith: tempDeclarationNodes
			sourceRange: (declarationStartIndex to: prevMark) ].
	^ self expected: 'Vertical bar'
! !

!TempVarDeclarationNodesParser methodsFor: 'nil' stamp: 'RNG 2/2/2020 23:33:34'!
temporaryBlockVariablesFor: aBlockNode
	"Scan and answer temporary block variables."

	| tempDeclarationNodes declarationStartIndex |
	(self match: #verticalBar) ifFalse:
		"There are't any temporary variables."
		[aBlockNode tempsMark: prevMark + requestorOffset.
		 ^ self noTempsDeclaration ].

	tempDeclarationNodes _ OrderedCollection new.
	declarationStartIndex _ prevMark.
	[hereType == #word] whileTrue: [
		self advanceWithRangeDo: [ :variableName :range |
			| variableNode |
			variableNode _ encoder bindBlockTemp: variableName within: aBlockNode range: range.
			tempDeclarationNodes addLast: (self createTempDeclarationOf: variableNode sourceRange: range) ] ].
	(self match: #verticalBar) ifFalse:
		[^self expected: 'Vertical bar'].
	aBlockNode tempsMark: prevMark + requestorOffset.
	^ self
		createTempsDeclarationWith: tempDeclarationNodes
		sourceRange: (declarationStartIndex to: prevMark)! !

!TemporariesDeclarationNode methodsFor: 'initialization' stamp: 'RNG 1/15/2020 07:35:56'!
initializeWithAll: aCollectionOfTempDeclarationNodes

	tempDeclarationNodes _ aCollectionOfTempDeclarationNodes! !

!TemporariesDeclarationNode methodsFor: 'printing' stamp: 'RNG 2/2/2020 12:55:49'!
printEachTempVarDeclarationOn: aStream

	^ tempDeclarationNodes do: [ :tempDeclarationNode |
		aStream nextPutAll: tempDeclarationNode variableName; space]! !

!TemporariesDeclarationNode methodsFor: 'printing' stamp: 'RNG 2/2/2020 12:55:49'!
printOn: aStream indent: anInteger

	aStream nextPut: $|; space.
	self printEachTempVarDeclarationOn: aStream.
	aStream nextPut: $|.! !

!TemporariesDeclarationNode methodsFor: 'accessing' stamp: 'RNG 2/2/2020 16:56:11'!
allDeclaredVariableNodes

	^ tempDeclarationNodes collect: [ :tempDeclaration | tempDeclaration variableNode ]! !

!TemporariesDeclarationNode class methodsFor: 'instance creation' stamp: 'RNG 2/2/2020 17:08:22'!
empty

	^ self withAll: #()! !

!TemporariesDeclarationNode class methodsFor: 'instance creation' stamp: 'RNG 1/15/2020 07:35:28'!
withAll: tempDeclarationNodes

	^ self new initializeWithAll: tempDeclarationNodes! !

!TemporaryDeclarationNode methodsFor: 'accessing' stamp: 'RNG 2/2/2020 16:55:54'!
variableName

	^ self variableNode name! !

!TemporaryDeclarationNode methodsFor: 'accessing' stamp: 'RNG 2/2/2020 16:55:48'!
variableNode

	^ variableNode! !

!TemporaryDeclarationNode methodsFor: 'initialization' stamp: 'RNG 1/15/2020 07:27:21'!
initializeVariableNode: aVariableNode

	variableNode _ aVariableNode! !

!TemporaryDeclarationNode methodsFor: 'printing' stamp: 'RNG 1/15/2020 07:41:06'!
printOn: aStream indent: anInteger

	aStream nextPut: $|; space.
	variableNode printOn: aStream indent: anInteger.
	aStream space; nextPut: $|.! !

!TemporaryDeclarationNode class methodsFor: 'nil' stamp: 'RNG 1/15/2020 07:27:07'!
of: aVariableNode

	^ self new initializeVariableNode: aVariableNode! !

!Ejemplo methodsFor: 'nil' stamp: 'RNG 1/19/2020 21:48:02'!
m1
	"(self >>#m1) methodNode rawSourceRanges"
	"(self >>#m1) sourceCode copyFrom: 137 to: 143"

	| a b c |
	a _ 1.
	b _ 2.
	c _ 3.
	[
		| d e |
		d _ 4.
		e _ 5.
		d + e
	] value.
	^ a + b + c
! !

!Ejemplo methodsFor: 'nil' stamp: 'RNG 2/2/2020 16:58:41'!
m2
	"(self >>#m2) methodNode rawSourceRanges"
	

	^ [ :a | a + 2]! !

!BlockNode methodsFor: '*TempVarDeclarationNodes' stamp: 'RNG 2/2/2020 17:37:17'!
temporariesDeclaration: aTemporariesDeclarationNode

	temporariesDeclaration := aTemporariesDeclarationNode.
	self temporaries: aTemporariesDeclarationNode allDeclaredVariableNodes! !

!MethodNode methodsFor: '*TempVarDeclarationNodes' stamp: 'RNG 2/2/2020 17:30:26'!
selector: selOrFalse arguments: args precedence: p temporariesDeclaration: tempsDeclaration block: blk encoder: anEncoder primitive: prim properties: propDict
	"Initialize the receiver with respect to the arguments given."

	encoder := anEncoder.
	selectorOrFalse := selOrFalse.
	precedence := p.
	arguments := args.
	temporariesDeclaration _ tempsDeclaration.
	temporaries := tempsDeclaration allDeclaredVariableNodes.
	block := blk.
	primitive := prim.
	properties := propDict.! !

!MethodNode methodsFor: '*TempVarDeclarationNodes' stamp: 'RNG 2/2/2020 17:29:40'!
selector: selOrFalse arguments: args precedence: p temporariesDeclaration: tempsDeclaration block: blk encoder: anEncoder primitive: prim properties: propDict selectorKeywordsRanges: range
	
	selectorKeywordsRanges := range.
	
	^self selector: selOrFalse arguments: args precedence: p temporariesDeclaration: tempsDeclaration block: blk encoder: anEncoder primitive: prim properties: propDict ! !
