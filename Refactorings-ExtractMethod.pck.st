'From Cuis 5.0 of 7 November 2016 [latest update: #3771] on 28 May 2019 at 1:01:13 am'!
'Description Extract Method refactoring.'!
!provides: 'Refactorings-ExtractMethod' 1 6!
SystemOrganization addCategory: #'Refactorings-ExtractMethod'!


!classDefinition: #ExtractMethod category: #'Refactorings-ExtractMethod'!
Refactoring subclass: #ExtractMethod
	instanceVariableNames: 'intervalToExtract sourceMethod newSelector categoryOfNewSelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethod class' category: #'Refactorings-ExtractMethod'!
ExtractMethod class
	instanceVariableNames: ''!

!classDefinition: #ExtractMethodApplier category: #'Refactorings-ExtractMethod'!
RefactoringApplier subclass: #ExtractMethodApplier
	instanceVariableNames: 'intervalToExtract methodToExtractCodeFrom newSelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodApplier class' category: #'Refactorings-ExtractMethod'!
ExtractMethodApplier class
	instanceVariableNames: ''!

!classDefinition: #ExtractMethodNewSelectorPrecondition category: #'Refactorings-ExtractMethod'!
RefactoringPrecondition subclass: #ExtractMethodNewSelectorPrecondition
	instanceVariableNames: 'selectorToValidate classToDefineSelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodNewSelectorPrecondition class' category: #'Refactorings-ExtractMethod'!
ExtractMethodNewSelectorPrecondition class
	instanceVariableNames: ''!

!classDefinition: #ExtractMethodEditorMenu category: #'Refactorings-ExtractMethod'!
Object subclass: #ExtractMethodEditorMenu
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodEditorMenu class' category: #'Refactorings-ExtractMethod'!
ExtractMethodEditorMenu class
	instanceVariableNames: ''!

!classDefinition: #ExtractMethodIntervalTrimmer category: #'Refactorings-ExtractMethod'!
Object subclass: #ExtractMethodIntervalTrimmer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodIntervalTrimmer class' category: #'Refactorings-ExtractMethod'!
ExtractMethodIntervalTrimmer class
	instanceVariableNames: ''!


!ExtractMethod methodsFor: 'initialization' stamp: 'RNG 5/8/2019 23:39:59'!
initializeFrom: anIntervalToExtract of: aMethodToExtractCodeFrom to: aNewSelector in: aCategory 

	intervalToExtract _ anIntervalToExtract.
	sourceMethod _ aMethodToExtractCodeFrom.
	newSelector _ aNewSelector.
	categoryOfNewSelector _ aCategory! !

!ExtractMethod methodsFor: 'applying' stamp: 'RNG 4/29/2019 00:45:18'!
apply

	self
		defineExtractedMethod;
		changeExistingMethod! !

!ExtractMethod methodsFor: 'applying' stamp: 'RNG 5/8/2019 23:34:19'!
changeExistingMethod

	sourceMethod methodClass
		compile: self updatedSourceCodeOfExistingMethod
		classified: sourceMethod category! !

!ExtractMethod methodsFor: 'applying' stamp: 'RNG 5/8/2019 23:40:24'!
defineExtractedMethod

 	sourceMethod methodClass
		compile: self newMethodSourceCode
		classified: categoryOfNewSelector! !

!ExtractMethod methodsFor: 'source code' stamp: 'RNG 5/28/2019 00:32:43'!
newMethodSourceCode

	| extractedSource parseNode return |
	extractedSource _ sourceMethod sourceCode copyFrom: intervalToExtract first to: intervalToExtract last.
	parseNode _ Parser parse: extractedSource class: sourceMethod methodClass noPattern: true.
	return _ parseNode block statements size = 1 ifTrue: [ '^ ' ] ifFalse: [ '' ].
	^ newSelector asString , String lfString , String lfString , String tab , return , extractedSource! !

!ExtractMethod methodsFor: 'source code' stamp: 'RNG 5/28/2019 00:35:18'!
updatedSourceCodeOfExistingMethod

	^ sourceMethod sourceCode
		copyReplaceFrom: intervalToExtract first
		to: intervalToExtract last
		with: 'self ', newSelector asString! !

!ExtractMethod class methodsFor: 'instance creation' stamp: 'RNG 5/8/2019 23:39:31'!
fromInterval: anIntervalToExtract of: aMethodToExtractCodeFrom to: aNewSelector categorizedAs: aCategory 

	self
		ensure: aNewSelector canBeDefinedIn: aMethodToExtractCodeFrom methodClass;
		ensure: anIntervalToExtract isValidIntervalOn: aMethodToExtractCodeFrom.

	^ self new
		initializeFrom: anIntervalToExtract
		of: aMethodToExtractCodeFrom
		to: aNewSelector
		in: aCategory! !

!ExtractMethod class methodsFor: 'validations' stamp: 'RNG 5/4/2019 22:40:07'!
ensure: aSelector canBeDefinedIn: aClass 

	ExtractMethodNewSelectorPrecondition valueFor: aSelector on: aClass! !

!ExtractMethod class methodsFor: 'validations' stamp: 'RNG 5/28/2019 00:02:12'!
ensure: anIntervalToExtract isValidIntervalOn: aMethodToExtractCodeFrom 

	self is: anIntervalToExtract withinBoundsOf: aMethodToExtractCodeFrom sourceCode
		:: ifFalse: [ self signalOutOfBoundsIntervalError ].
	self method: aMethodToExtractCodeFrom containsAValidExpressionOn: anIntervalToExtract
		:: ifFalse: [ self signalSelectedCodeIsInvalidForExtractError ].! !

!ExtractMethod class methodsFor: 'error messages' stamp: 'RNG 4/20/2019 21:53:45'!
outOfBoundsSelectionErrorMessage

	^ 'The source code selection interval is out of bounds'! !

!ExtractMethod class methodsFor: 'error messages' stamp: 'RNG 5/12/2019 23:42:45'!
selectedCodeInvalidForExtractErrorMessage

	^ 'The selected code can not be extracted to a method'! !

!ExtractMethod class methodsFor: 'exceptions' stamp: 'RNG 4/20/2019 21:53:24'!
signalOutOfBoundsIntervalError

	self refactoringError: self outOfBoundsSelectionErrorMessage! !

!ExtractMethod class methodsFor: 'exceptions' stamp: 'RNG 5/12/2019 23:54:19'!
signalSelectedCodeIsInvalidForExtractError

	self refactoringError: self selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/27/2019 23:44:36'!
containsValidNodes: parseNodeOnePath and: parseNodeTwoPath toExtract: anIntervalToExtract of: aMethodNode

	^ self isNotLeftSideOfAssignmentFrom: parseNodeOnePath to: parseNodeTwoPath
		:: and: [ self thereAreNoReturnExpressionsIn: anIntervalToExtract of: aMethodNode ]! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/26/2019 00:36:17'!
interval: anIntervalToExtract isBeginningOfStatementIn: parseNodePath

	^ parseNodePath last value first = anIntervalToExtract first! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/28/2019 00:21:55'!
interval: anIntervalToExtract isEndOfStatementIn: parseNodePath

	^ parseNodePath last value last = anIntervalToExtract last! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/28/2019 00:46:14'!
interval: anIntervalToExtract of: sourceCode containsCompleteAstNodeOn: parseNodeOne and: parseNodeTwo

	| actualInterval trimmedFirstInterval |
	"workaround for literals that have an extra space on the source range beginning"
	trimmedFirstInterval _ ExtractMethodIntervalTrimmer trim: parseNodeOne value accordingTo: sourceCode.
	actualInterval _ trimmedFirstInterval first to: parseNodeTwo value last.

	^ actualInterval = anIntervalToExtract! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/28/2019 00:22:21'!
is: anIntervalToExtract withinBoundsOf: aSourceCode

	^ anIntervalToExtract first >= 1 and: [ anIntervalToExtract last <= aSourceCode size ]! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/27/2019 23:48:10'!
isLeftSideOfAssignment: parseNodeOnePath

	^ parseNodeOnePath size > 1
		:: and: [ parseNodeOnePath second key isAssignmentNode]
		:: and: [ parseNodeOnePath second key variable = parseNodeOnePath first key ]! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/27/2019 23:30:09'!
isNotLeftSideOfAssignmentFrom: parseNodeOnePath to: parseNodeTwoPath

	^ (parseNodeOnePath first key = parseNodeTwoPath first key and:
		[ self isLeftSideOfAssignment: parseNodeOnePath]) not! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/28/2019 00:22:43'!
method: aMethod containsAValidExpressionOn: anIntervalToExtract

	| methodNode parseNodeOne parseNodeTwo firstNode secondNode parseNodeOnePath parseNodeTwoPath |
	methodNode _ aMethod methodNode.
	parseNodeOnePath  _ methodNode parseNodesPathAt: anIntervalToExtract first ifAbsent: [ ^ false].
	parseNodeTwoPath _ methodNode parseNodesPathAt: anIntervalToExtract last ifAbsent: [ ^ false ].
	
	parseNodeOne _ parseNodeOnePath first.
	parseNodeTwo _ parseNodeTwoPath first.
	firstNode _  parseNodeOne key.
	secondNode _ parseNodeTwo key.

	^ self interval: anIntervalToExtract of: aMethod sourceCode containsCompleteAstNodeOn: parseNodeOne and: parseNodeTwo
		:: and: [ self containsValidNodes: parseNodeOnePath and: parseNodeTwoPath toExtract: anIntervalToExtract of: methodNode ]
		:: and: [ firstNode = secondNode
			:: or: [ self sharesParentNodeCoveredBy: anIntervalToExtract for: parseNodeOnePath and: parseNodeTwoPath ]
			:: or: [ self interval: anIntervalToExtract isBeginningOfStatementIn: parseNodeOnePath
				:: and: [ self interval: anIntervalToExtract isEndOfStatementIn: parseNodeTwoPath ] ] ]! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/28/2019 00:23:00'!
sharesParentNodeCoveredBy: anIntervalToExtract for: parseNodeOnePath and: parseNodeTwoPath

	| parseNodesInCommon |
	parseNodesInCommon _ parseNodeOnePath intersection: parseNodeTwoPath.
	^ parseNodesInCommon notEmpty and: [ parseNodesInCommon first value = anIntervalToExtract ]! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/28/2019 00:04:00'!
thereAreNoReturnExpressionsIn: anIntervalToExtract of: aMethodNode

	aMethodNode rawSourceRanges keysAndValuesDo: [ :parseNode :sourceRange |
		parseNode isReturn
			:: and: [ anIntervalToExtract rangeIncludes: sourceRange first ]
			:: ifTrue: [ ^ false ] ].
	^ true! !

!ExtractMethodApplier methodsFor: 'refactoring - creation' stamp: 'RNG 5/13/2019 02:17:03'!
createRefactoring

	^ ExtractMethod
		fromInterval: intervalToExtract
		of: methodToExtractCodeFrom
		to: newSelector
		categorizedAs: methodToExtractCodeFrom category! !

!ExtractMethodApplier methodsFor: 'refactoring - parameters request' stamp: 'RNG 5/13/2019 02:21:23'!
askNewSelector

	newSelector _ (self request: 'New method name:') asSymbol! !

!ExtractMethodApplier methodsFor: 'refactoring - parameters request' stamp: 'RNG 5/13/2019 02:20:11'!
requestRefactoringParameters

	self askNewSelector! !

!ExtractMethodApplier methodsFor: 'refactoring - changes' stamp: 'RNG 5/13/2019 02:17:27'!
showChanges! !

!ExtractMethodApplier methodsFor: 'initialization' stamp: 'RNG 5/13/2019 02:32:19'!
initializeFor: anIntervalToExtract of: aMethodToExtractCodeFrom

	intervalToExtract _ anIntervalToExtract.
	methodToExtractCodeFrom _ aMethodToExtractCodeFrom! !

!ExtractMethodApplier class methodsFor: 'pre-conditions' stamp: 'RNG 5/13/2019 02:06:39'!
assertCanApplyRefactoringOn: aMethodToExtractCodeFrom at: anIntervalToExtract

	ExtractMethod
		ensure: anIntervalToExtract
		isValidIntervalOn: aMethodToExtractCodeFrom! !

!ExtractMethodApplier class methodsFor: 'instance creation' stamp: 'RNG 5/28/2019 00:40:13'!
for: anIntervalToExtract of: aMethodToExtractCodeFrom

	| trimmedIntervalToExtract sourceCode |
	sourceCode _ aMethodToExtractCodeFrom sourceCode.
	trimmedIntervalToExtract _ ExtractMethodIntervalTrimmer trim: anIntervalToExtract accordingTo: sourceCode.
	
	self assertCanApplyRefactoringOn: aMethodToExtractCodeFrom at: trimmedIntervalToExtract.

	^ self new initializeFor: trimmedIntervalToExtract of: aMethodToExtractCodeFrom! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating' stamp: 'RNG 4/18/2019 16:02:13'!
value

	self
		assertNewSelectorIsNotEmpty;
		assertNewSelectorDoesNotContainSeparators;
		assertNewSelectorDoesNotStartWithANumber;
		assertNewSelectorDoesNotStartWithAnUppercaseLetter;
		assertNewSelectorIsNotAlreadyDefinedInTheClass! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'initialization' stamp: 'RNG 4/18/2019 16:04:44'!
initializeFor: aSelectorToValidate on: aClassToDefineSelector

	selectorToValidate _ aSelectorToValidate.
	classToDefineSelector _ aClassToDefineSelector! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 4/18/2019 15:11:55'!
signalNewSelectorCanNotBeEmptyError

	self refactoringError: self class newSelectorCanNotBeEmptyErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 5/5/2019 12:22:02'!
signalNewSelectorCanNotContainSeparatorsError

	self refactoringError: self class newSelectorCanNotContainSeparatorsErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 5/5/2019 12:22:34'!
signalNewSelectorCanNotStartWithANumberError

	self refactoringError: self class newSelectorCanNotStartWithANumberErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 4/18/2019 15:41:13'!
signalNewSelectorCanNotStartWithAnUppercaseLetterError

	self refactoringError: self class newSelectorCanNotStartWithAnUppercaseLetterErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 5/5/2019 12:22:40'!
signalNewSelectorIsAlreadyDefinedInTheClassError

	self refactoringError: self class newSelectorAlreadyDefinedOnTheClassErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 4/18/2019 15:13:52'!
assertNewSelectorDoesNotContainSeparators

	(selectorToValidate anySatisfy: [ :character | character isSeparator ])
		ifTrue: [ self signalNewSelectorCanNotContainSeparatorsError ]! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 5/5/2019 12:23:28'!
assertNewSelectorDoesNotStartWithANumber

	selectorToValidate first isDigit
		ifTrue: [ self signalNewSelectorCanNotStartWithANumberError ]! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 5/5/2019 12:23:23'!
assertNewSelectorDoesNotStartWithAnUppercaseLetter
	
	selectorToValidate first isUppercase
		ifTrue: [ self signalNewSelectorCanNotStartWithAnUppercaseLetterError ]! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 5/5/2019 12:23:12'!
assertNewSelectorIsNotAlreadyDefinedInTheClass

	(classToDefineSelector includesSelector: selectorToValidate)
		ifTrue: [ self signalNewSelectorIsAlreadyDefinedInTheClassError ]! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 5/5/2019 12:23:16'!
assertNewSelectorIsNotEmpty

	selectorToValidate ifEmpty: [ self signalNewSelectorCanNotBeEmptyError ]! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:58:58'!
newSelectorAlreadyDefinedOnTheClassErrorMessage

	^ 'New selector is already defined on this class'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 14:40:21'!
newSelectorCanNotBeEmptyErrorMessage

	^ 'New selector can not be empty'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:05:41'!
newSelectorCanNotContainSeparatorsErrorMessage

	^ 'New selector can not contain separators'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:34:30'!
newSelectorCanNotStartWithANumberErrorMessage

	^ 'New selector can not start with a number'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:41:13'!
newSelectorCanNotStartWithAnUppercaseLetterErrorMessage

	^ 'New selector can not start with an uppercase letter'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'instance creation' stamp: 'RNG 4/18/2019 16:01:43'!
for: aSelectorToValidate on: aClass 

	^ self new initializeFor: aSelectorToValidate on: aClass! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'evaluating' stamp: 'RNG 4/18/2019 15:59:44'!
valueFor: aSelectorToValidate on: aClass

	^ (self for: aSelectorToValidate on: aClass) value! !

!ExtractMethodEditorMenu class methodsFor: 'shortcuts' stamp: 'RNG 5/13/2019 01:25:03'!
smalltalkEditorCmdShortcutsSpec

	^#(#($M #extractMethod: 'Extracts the selected code into a separate method'))! !

!ExtractMethodEditorMenu class methodsFor: 'menu items' stamp: 'RNG 5/13/2019 01:21:46'!
smalltalkEditorMenuOptions

	^`{
		{
				#itemGroup 		-> 		35.
				#itemOrder 		-> 		20.
				#label 			-> 		'Extract Method... (M)'.
				#selector 		-> 		#extractMethod.
				#icon 			-> 		#saveAsIcon
		} asDictionary
	}`! !

!ExtractMethodIntervalTrimmer class methodsFor: 'evaluating' stamp: 'RNG 5/28/2019 00:42:57'!
trim: anInterval accordingTo: sourceCode

	| trimmedInterval |
	trimmedInterval _ anInterval.
	[ (sourceCode at: trimmedInterval first) isSeparator ]
		whileTrue: [ trimmedInterval _ trimmedInterval first + 1 to: trimmedInterval last ].
	[ (sourceCode at: trimmedInterval last) isSeparator ]
		whileTrue: [ trimmedInterval _ trimmedInterval first to: trimmedInterval last - 1 ].
	^ trimmedInterval! !

!ParseNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/26/2019 01:44:50'!
expandRange: aSourceRange basedOn: sourceRangesOfChildNode

	| intervals |
	intervals _ sourceRangesOfChildNode isInterval
		ifTrue: [ OrderedCollection with: sourceRangesOfChildNode ] ifFalse: [ sourceRangesOfChildNode ].
	intervals withIndexDo: [ :interval :index |
		(interval last > aSourceRange first) ifTrue: [
			^ (intervals at: index - 1 ifAbsent: [ intervals last]) first to: aSourceRange last ] ].
	^ intervals last first to: aSourceRange last.! !

!ParseNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/26/2019 00:45:37'!
expandRanges: sourceRanges basedOn: allSourceRanges

	^ sourceRanges! !

!Encoder methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/26/2019 00:38:01'!
expandedSourceRanges

	| expandedSourceRanges |
	expandedSourceRanges _ Dictionary new.
	sourceRanges keysAndValuesDo: [ :parseNode :nodeRanges |
		| expandedNodeSourceRanges |
		expandedNodeSourceRanges _ parseNode expandRanges: nodeRanges basedOn: sourceRanges.
		expandedSourceRanges at: parseNode put: expandedNodeSourceRanges ].
	^ expandedSourceRanges! !

!Encoder methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/25/2019 22:40:47'!
parseNodesPathAt: aPosition ifAbsent: aBlockClosure

	| nodesWithRangeAtPosition |
	nodesWithRangeAtPosition _ SortedCollection sortBlock: [ :nodePathOne :nodePathTwo |
		nodePathOne value first >= nodePathTwo value first and: [
			nodePathOne value last <= nodePathTwo value last ] ].

	self expandedSourceRanges associationsDo: [ :nodeAtRange |
		self withRangesOf: nodeAtRange including: aPosition do: [ :aRange |
			nodesWithRangeAtPosition add: (nodeAtRange key -> aRange) ] ].

	^ nodesWithRangeAtPosition
		ifEmpty: aBlockClosure
		ifNotEmpty: [ nodesWithRangeAtPosition ]! !

!AssignmentNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/26/2019 00:51:11'!
expandRanges: aSourceRange basedOn: sourceRanges

	^ self expandRange: aSourceRange basedOn: (sourceRanges at: variable)! !

!MessageNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/27/2019 23:14:21'!
expandRanges: aSourceRange basedOn: sourceRanges

	| receiverExpandedRanges |
	receiverExpandedRanges _ self isCascade
		ifTrue: [ self flag: #todo . aSourceRange ]
		ifFalse: [ receiver expandRanges: (sourceRanges at: receiver) basedOn: sourceRanges ].
	^ self expandRange: aSourceRange basedOn: receiverExpandedRanges! !

!MethodNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/26/2019 00:44:05'!
expandedSourceRanges

	^ encoder expandedSourceRanges! !

!MethodNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/26/2019 00:44:08'!
parseNodesPathAt: aPosition ifAbsent: aBlockClosure

	^ encoder parseNodesPathAt: aPosition ifAbsent: aBlockClosure! !

!SmalltalkEditor methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/28/2019 00:59:01'!
extractMethod

	"hack to prevent the extract method to be evaluated on editors w/o methods like the workspace"
	(self codeProvider respondsTo: #currentCompiledMethod) ifFalse: [ ^ nil ].

	morph owningWindow okToChange ifTrue: [
		ExtractMethodApplier createAndValueHandlingExceptions: [
			ExtractMethodApplier for: self selectionInterval of: self codeProvider currentCompiledMethod ] ]! !

!SmalltalkEditor methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/9/2019 00:06:54'!
extractMethod: aKeyboardEvent

	self extractMethod.
	^true! !
