import KlangraumKit
/*:

# Guided Projekt Typ B - Evaluierung von Methoden eines Klangmanagements zur Anpassung von Klangräumen an die Wahrnehmung

Interaktive Playground Dokumentation

ausgearbeitet von Alexander Dobrynin und Pascal Schönthier

im Studiengang Informatik Master - Software Engineering

betreut durch Prof. Dr. Lutz Köhler

## Inhaltsverzeichnis

1. [Einleitung](#Einleitung)
2. [Grundlagen](#Grundlagen)
3. [Theoretische Überlegungen, Konzeption und Umsetzung](#Theoretische-Überlegungen,-Konzeption-und-Umsetzung)
5. [Beispiel anhand eines Anwendungsfalls](#Beispiel)
4. [Abschluss](#Abschluss)

## Kurzfassung

Die vorliegende Arbeit wurde im Rahmen des Guided-Project Typ B im Informatik Master, Schwerpunkt Software-Engineering, an der Fachhochschule Köln am Campus Gummersbach durchgeführt. Die Aufgabe des Guided-Project handelt um die Evaluierung von Methoden eines Klangmanagements zur Anpassung von Klangräumen an die Wahrnehmung.

Das Projekt befasst sich mit der Anpassung des Klangraumes an die individuelle Wahrnehmung. Hierfür wurde ein Kontext definiert, welcher die Rahmenbedingung für die Anpassung beschreibt. Daraufhin wurden Methoden und Techniken explorativ erkundet, um sich dem Thema zu nähern. Alle Ergebnisse befinden sich im vorliegenden Xcode Projekt sowohl in Form einer iOS-App, als auch im interaktiven Playground.

Das Evaluieren von Methoden bezieht sich auf die Auswahl von Algorithmen, welche die Anpassung von Klangräumen vornehmen. Die Algorithmen an sich wurden nicht intensiv evaluiert. Stattdessen wurde eher ein Framework für das Anpassen der Klangräume an die Wahrnehmung des Menschen als iOS-App entwickelt. Dabei wurde das Framework so modular entwickelt, dass die Methoden bzw. Algorithmen dynamisch zur Laufzeit ausgetauscht werden können, um die Qualität der Wahrnehmung zu steigern. Somit können die Ergebnisse einer Evaluation des Klangmanagements als Implementierung in die Anwendung einfließen und zur individuellen Anpassung des Klangraumes beitragen.

## Einleitung

Das Projekt wurde aus eigenem Interesse vorgeschlagen und dahingehend formuliert, dass es sowohl einen wissenschaftlichen Anspruch hat, als auch eine explorative Herangehensweise beinhaltet. Grundlagen und Methoden wurden fundiert erhoben, gegeneinander abgewogen und qualitativ bewertet. Der Prozess und die Implementierung wurden wiederum agil und auf Basis des aktuellen Wissensstandes geprägt. Insgeasmt war das Vorgehen ergebnisorientiert, weshalb das vorliegende Dokument als interaktives Playground geschrieben ist. Aus diesem Grund steht die Implementierung im Vordergrund, die Prosa dient der Beschreibung und Argumentation. Zudem kann sie als roter Faden verstanden werden.

Im Folgenden soll die Arbeit mit einer kurzen Motivation eingeleitet werden. Danach folgt die Beschreibung des Ziels und dem Vorgehen, um das Ziel zu erreichen. Damit eine konkrete Anwendung entwickelt und getestet werden kann, wird ein Kontext definiert, welcher den Rahmen des Anwendungsfalls beschreibt und eingrenzt. Anschließend wird die Organisation des Dokumentes als interaktiven Playgrounds erläutert.

### Motivation

Jeder Mensch verliert im Laufe seines Lebens die Fähigkeit bestimmte Frequenzbereiche zu perzipieren. Die notwendige Hardware und Software, um Manipulationen an Audio-Dateien durchzuführen, tragen viele Menschen in Form vom Smartphones mit sich. Deshalb liegt es Nahe, ausgewählte Audio-Dateien vor dem Kosumieren an die Wahrnehmung des Menschen individuell anzupassen.

### Ziel und Vorgehen

Das primäre Ziel ist es, Möglichkeiten zum Verbessern bzw. Ausbessern des Frequenzverlustes anhand bestehender Audio-Aufnahmen zu evaluieren. Hierfür werden Ansätze in Form von Konzepten und Algorithmen recherchiert, gegeneinander abgewogen und in einer iOS-Anwendung implementiert. Dessen Wirksamkeit, Realisierbarkeit und Performanz im gegebenen Kontext steht hierbei im Vordergrund. Performanz deshalb, weil eine Verarbeitung in Echtzeit angestrebt wird.

Das sekundäre Ziel befasst sich mit Begriffsdefinitionen bezüglich dem Klangmanagment, des Klangraumes und der Klangwahrnehmung. Hierbei soll an die Verwandten Begriffe des Farbmangement, Farbraum und Farbwahrnehmung angelehnt werden.

### Kontext

Um die Algorithmen und Konzepte angemessen zu testen, soll ein Nutzungskontext der Anwendung definiert werden. Gleichzeitig dient der Nutzungskontext als Orientierungshilfe bei Entscheidungen und als Rahmen für die Projektgrenzen.

Der Kontext umfasst ein iPhone mit iOS 8 oder höher. Als Audio-Datei dienen Podcasts, die zum größten Teil aus menschlichen Stimmen bestehen. Allerdings wird auch Musik in den verschiedensten Formaten eingespielt, weshalb dieser Frequenzbereich ebenfalls berücksichtigt werden soll.

Bibliotheken und Schnittstellen sind nicht vorgeschrieben. Da die Anwendung in Swift entwickelt werden soll, sollten die verwendeten APIs möglichst selbst in Swift implementiert sein. Alternativ kann ein Objective-C oder sogar C-Bridging für *low-level* Verarbeitung eingesetzt werden.

### Organisation des Dokumentes

Das vorliegende Dokument ist als interaktives Playground organisiert. Während [Kapitel 1](#Einleitung) und [2](#Grundlagen) noch vollständig aus Text bestehen, ist [Kapitel 3](#Theoretische-Überlegungen,-Konzeption-und-Umsetzung) in einem Wechsel zwischen Text und Quellcode organisiert. Der Quellcode wird dynamisch kompiliert, weshalb der Leser Änderungen am Quellcode vornehmen kann, welche anschließend neu kompiliert und ggf. angezeigt werden. Das [letzte Kapitel](#Abschluss) ist ebenfalls klassisch, um das Fazit und die persönliche Einschätzung möglichst präzise, schlüssig und vieldimensional zu Gestalten.

Das interaktive Playground ist eine Form der Quellcode Dokumentation. Demnach steht hierbei der Quellcode im Vordergrund, welcher interaktiv ist, was bedeutet, dass der Quellcode kompiliert, ausgeführt wird und dessen Ergebnis live angezeigt oder sogar geplottet wird. Der Fließtext dient als roter Faden und erklärt das Vorgehen, die Gedanken und Überlegungen, die Abwägungen von Alternativen und die Begründungen von Entscheidungen. Neben dem interaktiven Quellcode finden sich *Sourcecode-Listings*, welche der iOS-App entstammen. Diese wurde eingefügt, um die Argumentationen mit Quellcode zu führen und Beispiele für die Implementierung zu zeigen.

## Grundlagen
In dem folgenden Abschnitt sollen die Grundlagen geklärt werden. Zu diesem Zweck werden zuerst einige Begriffe geklärt, die in der weiteren Ausarbeitung Verwendung finden sollen.

### Begriffsdefinitionen
Die Erläuterung der Begriffe teilt sich hier in zwei Kategorien auf, zum einen die allgemeinen Begriffe zum beschreiben der äußeren Umstände und zum verdeutlichen der Anwendung.  Zum anderen sollen die Fachspezifischen Begrifflichkeiten, die Audio und die Signalverarbeitung angehen, auch an dieser Stelle umschreiben werden.

Zuerst soll sich an dieser Stelle jedoch der allgemeinen Begriffsdefinition gewidmet werden. Zu diesem Zweck wurden, wie nachfolgend aufgelistet, drei Begriffe definiert.

* **Klangmanagement:** Unter diesem Begriff soll innerhalb dieser Ausarbeitung die Bearbeitung von AudioSignalen mittels Digitaler Signalverarbeitung und deren Algorithmen verstanden werden. Beim Klangmanagement geht es vor allem um eine subjektive verbesserte Wahrnehmung. In diesem Kontext bedeutet das, der Hörer soll nach der Anwendung des Klangmanagements mehr von der Audio-Datei wahrnehmen kann als es im Orginal-Zustand der fall wäre.

* **Klangraum:** Hier wurde der Begriff fachlich an den Begriff des Farbraumes angelehnt. Ähnlich des Farbraumes, bei dem es um die vereinheitlichte Darstellung der Farben geht, soll der Klangraum für eine Vergleichbarkeit von Klängen sorgen. Dies ist im allgemeinen ein Schwieriges Unterfangen, da bei Audio viele Parameter einfließen, die bei Monitoren nicht gelten. So ist es unter anderem wichtig, in welchem Raum die Klänge ertönen sollen, sowie der Resonanzkörper in dem die Lautsprecher verbaut wurden.

* **Klangwahrnehmung:** Innerhalb des Ausarbeitungskontextes soll dieser Begriff explizit die subjektive Wahrnehmung von Klang erläutern. Subjektiv aus dem einfachen Grund, dass eine objektive Wahrnehmung nicht im Rahmen dieses Guided Projects vorgenommen werden kann, da hierzu die entsprechenden Messgeräte fehlen.



Nachdem die übergeordneten Begriffe geklärt wurden, widment wir uns nun den technischeren Begriffen. Hierunter fallen die nachfolgend aufgelisteten.

**Das musst du machen.**

* **Amplitude:** Unter einer Amplitude wird eine Größeneinheit verstanden, mittels derer sich Schwingung darstellen lässt. Es existieren keine genormten Maßeinheiten somit wird für diese Ausarbeitung angenommen, dass es sich um positive Integer- bzw. Floatwerte – wie im linear Pulse Code Modulation (PCM) Standart verwendet – handelt
* **Signal:** Die Audio-Datei in grafischer bzw. programatischer Representation. Hierunter fällt die Darstellung innerhalb eines Diagramms, als Array von diskreten Werten. Im Wesentlichen handelt es sich hierbei um die An
* **Sample:** Beschreibt einen Messpunkt innerhalb eines Signals, im programatischen typischerweise ein Integer oder Float wert der den Amplituden-Ausschlag beschreibt
* **Samplerate:** Auch Abtastrate, beschreibt die Anzahl der erstellten Samples pro Sekunde
* **Fourier Transformation:** Wandelt das Signal in die spektrale Darstellung. In der spektralen Darstellung an Stelle von Amplituden werden Frequenzen dargestellt die als Magnitude beschrieben werden.
* **Magnitude:** Beschreibt den Amplituden ähnlichen Ausschlag eines Signal, jedoch zu einer bestimmten Frequenz – typischerweise in Hertz(Hz) gemessen.
* **Bin:** Beschreibt einen Eintrag des Fourier-Outputs, ein Bin umfasst einen Frequenzbereich, die Ausgegebenen Frequenzbereiche sind untereinander Harmonisch.
* **Mapping:** Im Rahmen dieser Ausarbeitung steht Mapping für das überführen von einem Frequenzbereich in einen anderen
* **Strategien:** Als Stretegie wird im Rahmen dieser Ausarbeitung die Implementierung eines Mapping-Ansatzes beziehungsweise eines Filters oder sonstiger Signalverarbeitung verstanden

**Hierfür müssen wir uns absprechen.**

### Auditive Wahrnehmung
Unter auditiver Wahrnehmung wird die Sinneswahnehmung von auditiven, also akustischen Reizen verstanden. Um diese auditive Reize aufnehmen zu können, entwickelte sich im laufe der Evolution das Ohr.

Das Ohr, übersetzt Schall über ein komplexes System bestehend aus dem äußerden Gehörgang, der zu einer Membrane führt die »**Trommelfell**« genannt wird. Das Trommelfell überträgt die Schwindung der Luft auf den einen Knochen der »**Hammer**« genannt wird. Die hieraus resultierende Bewegung wird über den »**Amboss**« genannten Knochen weiter an den »**Steigbügel**« geleitet. Dieser Überträgt das "Signal" an die »**Bogengänge**« und die »**Hörschnecke**«, die für die Wahrnehmung des Schalls zuständig sind. Einfach erläutert sorgt eine Flüssigkeit innerhalb der Schnecke dafür, dass die Schallwellen innerhalb der Flüssigkeit übertragen werden und kleine Haare innerhalb der Hörschnecke reizen. Dabei gilt, je weiter das Haar gegen Ende des "Schneckenhauses" desto höher der Ton und desto feiner das Haar. Die Nervenreize, die durch die Bewegung des Haars hervorgerufen werden, gehen dann über den Hörnerv ans Gehirn, welches die Ergebnisse dann Interpretiert.

Es ist nicht schwer zu erkennen, dass dieser Vorgang viel Spiel und Interpretationsspielraum zulässt, außerdem ist es nicht unwahrscheinlich, dass die Haare, die für höhere Frequenzen zuständig sind, nicht mehr wie gewohnt reagieren bzw. ausfallen. Dies führt im laufe der Zeit zu einem Hörverlust in den höheren Frequenzbereichen. Aber auch ein Hörverlust in den niederen Frequenzen ist durchaus denkbar. Dieser Umstand erschwert die Beschreibung der Wahrnehmung. Jedoch wird aus diesem Grund auch erst einiges Möglich, so ist das Gehirn darauf fokusiert diese Reize zu interpretieren, was ständiges Lernen vorraussetzt.

Um, wie in diesem Projekt angestrebt, die Auditive Wahrnehmung zu verbessern, wurde sich im Rahmen dieser Ausarbeitung vor allem mit dem Übertragen von Frequenzen auf einen "kleineren" Frequenzbereich fokussiert. Dies kann durchaus für eine Subjektive Verschlechterung sorgen, jedoch gilt zu bedenken, dass so Informationen wieder an das Gehirn weitergeleitet werden, die vorher einfach verloren gegangen wären. Da das Gehirn diese Reize interpretiert soll an dieser Stelle die Behauptung aufgestellt werden, dass so in angemessener Zeit erlernt werden kann, was diese neuen Reize bedeuten sollen und somit wieder auf diese Informationen reagiert werden kann.

Wir fassen zusammen, unter auditiver Wahrnehmung wird in dieser Ausarbeitung der Wahrnehmungsprozess des Menschen verstanden, was die Interpretation durch das menschliche Gehirn einbezieht. Unter der Verbesserung der auditiven Wahrnehmung soll, gerade in dieser Ausarbeitung, die Anpassung der Audioaufnahme an das Hörvermögen des Benutzers verstanden werden.

### Digitale Signalverarbeitung
Die digitale Signalverarbeitung (engl. Digital Signal Processing) ist ein weitreichendes Themengebiet, so umfasst die digitale Signalverarbeitung unter anderem die Verarbeitung von Spannungen in Stromnetzen, die verarbeitung von digitalen Bildern oder von digitalen Audioformaten wie dem linear PCM Format. Im Rahmen dieser Dokumentation soll der Begriff digitale Signalverarbeitung als synonym für die Verarbeitung von digitalen Audioformaten dienen. Auch wenn der Begriff Audioverarbeitung augenscheinlich eindeutiger wäre, benutzen wir an dieser Stelle die digitale Signalverarbeitung, da so der zusammenhang der Algorithmen deutlicher wird.

Besonders sollen innerhalb dieser Dokumentation auf die Fouriertransformation eingegangen werden, die ein Signal in dessen Spektrum zerlegt. Dieser Vorgang lässt sich am besten durch die Metapher des Prisma erläutern. Die Fouriertransformation – in diesem Projekt durch die Fast-Fourier-Transformation realisiert – zerlegt ein Signal, ähnlich einem Prisma auf das Licht fällt, in die einzelnen Spektren – beim Licht die Farben die bei einem Regenbogen sichtbar sind. Durch diese Transformation lassen sich im Rahmen der Audioverarbeitung verschiedene Frequenzen analysieren, da auf diese Weise erst die Möglichkeit besteht diese aus der Audioaufnahme zu extrahieren.

Weitere Techniken, die innerhalb dieses Projektes Verwendung finden sind, High-Pass-Filter und Mapping Strategien. Die High-Pass-Filter werden benötigt um Störgeräusche aus der Audiodatei zu entfernen. Ein High-Pass-Filter lässt nur Signale oberhalb eines Thresholds durch, wird dieser der Signal-To-Noise-Ratio angepasst, also dem Wert der ein brauchbares Signal von einem Rauschen oder sonstigen Störgeräusch abgrenzt, können diese Störgeräusche einfach herausgefiltert werden.

Die Mapping Strategien werden benötigt, um die Informationen des Signals mit möglichst wenig Verlust auf einen kleineren Frequenzbereich abbilden zu können. Um dies zu realisieren, wurde die bestehende Aufnahme zuerst mittels linearer Interpolation auf einen höheren Samplingwert gesetzt. Bei diesem Verfahren werden neue Samples zwischen zwei bestehenden Samples mittels »linear Regression« errechnet und hinzugefügt. Nachdem die Aufnahme nun mehr Samples besitzt, in unserem fall soviele, dass es einen größten gemeinsamen Teiler(ggt) gibt, kann mittels downsampling auf die gewünschte Samplerate – bzw. in unserem Fall die »FFT Bins« – herunter gerechnet werden. Durch das upsampling und downsampling soll der Verlust beim Umrechnen minimiert werden, da zu beginn des downsamplings mehr Informationen zur Verfügung stehen, mehr zu diesem Ansatz im nächsten Kapitel.

## Theoretische Überlegungen, Konzeption und Umsetzung

In diesem Kapitel soll die explorative Herangehensweise beschrieben werden. Hinsichtlich der Projektbeschreibung und den Grundlagen der auditiven Wahrnehmung, wurde das folgende Konzept überlegt:

* **Hörtest**, um den hörbaren Frequenzbereich des Benutzers zu erfassen
* **Extrahieren von Samples in Mono und Stereo**, um die Audio-Datei anschließend angemessen bearbeiten zu können
* **Padding, Windowing und Splitting**, als Vorbereitung für die FFT
* **Manipulation der Samples mithilfe der FFT**, um das Audio-Signal an den Kontext des Benuters anzupassen
* **Modifizierte Samples als Audio-Datei abspielen**, um das Ergebnis zu hören
Die einzelnen Schritte können so komplex werden, dass an einigen Algorithmen und Methoden zwar eine ausreichende, aber nicht hinreichende Implementierung stattgefunden hat. Die detailierte Auseinandersetzung mit Audio-Algorithmen ist so umfangreich, dass sie ein eigenes Projekt mit Inhalt füllt. Aus diesem Grund ist die Implementierung der Anwendung als modulares Framework in Swift zum Manipulieren und Abspielen von Audio-Dateien für iOS-Systeme zu verstehen. 


Im Folgenden werden die einzelnen Schritte detailiert erklärt, begründet, implementiert und mithilfe des interaktiven Playgrounds vorgeführt.

### Hörtest

Um das Audio-Signal in einen für den Benutzer hörbaren Frequenzbereich anzupassen, muss zunächst der hörbare Frequenzbereich des Benutzers erfasst werden. Hierfür soll ein Hörtest implementiert werden, welcher das für den Mensch hörbaren Frequenzspektrum von 0 bis 22000 Hz mit einem akustischen Signal durchläuft. Sobald der Benutzer das Signal perzipiert drückt er auf eine dafür vorhergesehene Fläche und hält solange gedrückt, bis das Signal nicht mehr zu hören ist. Auf diese Weise erfasst und speichert das System die untere und obere Grenze an hörbaren Frequenzen. Die folgende Abbildung zeigt den Hörtest wie er in der iOS-Anwendung zu sehen ist:

![Hearing Test](hearingtest.png)

Der Hörtest wurde mithilfe von [AudioKit](http://audiokit.io) impementiert. AudioKit liefert eine umfangreiche Bibliothek für das Erzeugen und Verarbeiten von Audio auf Basis von Apples APIs. Glücklicherweise haben die Entwickler von AudioKit bereits ein Bridging Projekt von Objective-C auf Swift bereitgestellt, weshalb die Anbindung problemlos verlief.

Im Folgenden wird eine gekürzte Implementierung des *HearingTestViewController* vorgestellt. Dieser erzeugt ein *ToneWidget*, welcher im Verlauf von 60 Sekunden ein Signal von 0 bis 22000 Hz generiert. Ein Blick in *Constants* zeigt die Konfiguration des Hörtests.

    struct Constants {
        static let StopToneGeneratorNotification = "stopToneGeneratorNotification"
        
        static let maxFrequency = "maxFrequency"
        static let minFrequency = "minFrequency"
        
        static let amplitude: Float = 0.25
        static let numInstruments = 1
        static let frequencyScale: Float = 22000
    }
In dem folgenden Abschnitt sollen die Grundlagen geklärt werden. Zu diesem Zweck werden zuerst einige Begriffe geklärt, die in der weiteren Ausarbeitung Verwendung finden sollen.

Theoretisch lässt sich die Anzahl der ToneWidgets mit *numInstruments* steuern, um einen dedizierten Hörtest für beide Ohren durchzuführen. Aus diesem Grund wurde ein Array von ToneWidget angelegt. Des Weiteren lässt sich die Amplitude über *amplitude* ansteuern. In der *viewDidLoad* Funktion werden ToneWidget und SoundGenerator angelegt. Die *start* Funktion lässt den Hörtest solange laufen, wie der Benutzer auf das ToneWidget drückt. Erst wenn kein Ton mehr zu hören ist, lässt der Benutezr los, wodurch die *stop* Funktion aufgerufen wird. Da die Gesten im ToneWidget implementiert sind, ruf das Widget über das Notification-Pattern die *onStartAndStop* Funktion aus. Diese speichert die übergebene min- und max Frequenz. Diese beiden Schranken geben den vom Benutzer hörbaren Frequenzbereich an.

    class HearingTestViewController: UIViewController {
        
        private var nsTimer: NSTimer?
        
        var toneWidgets = [ToneWidget]()
        let soundGenerator = SoundGenerator()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            soundGenerator.setUp()
            
            for i in 0 ..< Constants.numInstruments {
                let toneWidget = ToneWidget(channelNumber: i, frame: CGRectZero)
                
                toneWidget.addTarget(self, action: "toneWidgetChangeHandler:", forControlEvents: UIControlEvents.ValueChanged)
                
                toneWidgets.append(toneWidget)
                view.addSubview(toneWidget)
            }
        }
        
        @IBAction func start(sender: UIBarButtonItem) {
            guard let toneWidget = toneWidgets.first where Constants.numInstruments == 1 else { return }
            
            soundGenerator.playNoteOn(toneWidget.getFrequencyAmplitudePair(), channelNumber: 0)

            nsTimer = NSTimer.scheduledTimerWithTimeInterval(1.0 / Double(Constants.frequencyScale * 60), target: self, selector: Selector("increase"), userInfo: nil, repeats: true)

          NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("stop"), name: Constants.StopToneGeneratorNotification, object: nil)
        }
        
        func stop() {
            if let timer = nsTimer { timer.invalidate() }
            
            soundGenerator.stop()
            navigationItem.rightBarButtonItem?.enabled = true
        }
        
        func increase() {
            toneWidgets.first?.currentValue += 1.0 / Float(Constants.frequencyScale / 10)
            toneWidgets.first?.dialChangeHander()
        }
        
        func onStartAndStop(minFrequency: Float, maxFrequency: Float) {
            NSUserDefaults.standardUserDefaults().setFloat(minFrequency, forKey: Constants.minFrequency)
            NSUserDefaults.standardUserDefaults().setFloat(maxFrequency, forKey: Constants.maxFrequency)
        }
    }
       
Im Rahmen des Prototypen wurde lediglich der Hörtest ohne Berücksichtung von Stereo implementiert. Des Weiteren wird zwar das Regulieren der Amplitude ermöglicht, allerdings nicht in Relation zur Frequenz erfasst. Für die Validierung des Konzeptes wird lediglich der vom Benutzer hörbare Frequenzbereich benötigt. Die Granularität hat keine Auswirkung auf das Vorgehen. Die oben gezeigte Implementierung liefert hierfür dennoch die notwendigen Schnittstellen.

### Manipulation der Samples mithilfe der FFT

Der Kern der Anwendung befasst sich mit der FFT. Die Implementierung muss in der Lage sein, eingehende Samples von einer zeitbasierten Darstellung in eine frequenzbasierte Darstellung zu überführen. In der frequenzbasierten Darstellung liegen die Daten als komplexe Zahlen vor. Die Anwendung muss ebenfalls in der Lage sein, aus den komplexen Zahlen reale Zahlen oder Polarkoordinaten zu extrahieren. Mithilfe dieser Operationen wird das Signal bearbeitet. Anschließend muss eine inverse FFT implementiert werden, welche die komplexen Zahlen in Samples überführt. Das Manipulieren des Signals sollte modular implementiert werden, sodass man nachträglich Audio-Algorithmen hinzufügen und zur Laufzeit austauschen kann.

Die API zum Umgang mit der FFT sollte die oben genannten Anforderungen erfüllen. Im Kontext von iOS bietet Apple selbst eine API zur digitalen Signalverarbeitung namens [vDSP](https://developer.apple.com/library/prerelease/ios/documentation/Accelerate/Reference/vDSPRef/index.html) an. vDSP nutzt das [Accelerate Framework](https://developer.apple.com/library/prerelease/tvos/documentation/Accelerate/Reference/AccelerateFWRef/index.html#other), welches eine C-API zum Verarbeiten von Vektoren, Matrizen, digitalen Signalen, Bildern usw. anbietet. Einen leichtgewichtigen Wrapper um die *low-level* APIs gibt es nicht, vor allem nicht für Swift. Aus diesem Grund kommt eine weitere Herausforderung hinzu: die Nutzung von C-artigen, adress- und pointerbasierten Funktionen in einer modernen Programmiersprache, die aus der Intention heraus entwickelt wurde, seinen C-Balast abzuwerfen. Unabhängig davon, fällt die Wahl auf vDSP und dem Accelerate Framework, da beide APIs von Apple für iOS Systeme angeboten werden, um digitale Signalverarbeitung zu vermöglichen. Des weiteren scheint die Benutzung beider APIs eher mit Swift zu harmonieren, als eine andere reine C oder C++ API. Das wichtige Kriterium ist jedoch, dass beide APIs laut dem [vDSP Reference Guide](https://developer.apple.com/library/prerelease/tvos/documentation/Accelerate/Reference/vDSPRef/index.html#//apple_ref/doc/uid/TP40009464) die oben genannten Anforderungen erfüllen.

#### FFT Datenstrukturen

Die Implementierung der FFT-Komponente beginnt mit den Datenstrukturen. Die Funktionen der vDSP API sind so aufgebaut, dass sie, neben primitiven Parametern wie *Int* und *Double*, *UsafePointer* und *UnsafeMutablePointer* entgegennehmen oder zurückgeben:


    import Accelerate

    func vDSP_zvmags(__A: UnsafePointer<DSPSplitComplex>, _ __IA: vDSP_Stride, _ __C: UnsafeMutablePointer<Float>, _ __IC: vDSP_Stride, _ __N: vDSP_Length) {}
    func vDSP_mmul(__A: UnsafePointer<Float>, _ __IA: vDSP_Stride, _ __B: UnsafePointer<Float>, _ __IB: vDSP_Stride, _ __C: UnsafeMutablePointer<Float>, _ __IC: vDSP_Stride, _ __M: vDSP_Length, _ __N: vDSP_Length, _ __P: vDSP_Length) {}

Die erste Funktion extrahiert die *Magnitudes* aus einer komplexen Zahl. Die zweite Funktion multipliziert zwei Arrays, die wiederum Magnitudes sein können. UsafePointer und UnsafeMutablePointer werden benutzt, um mit den Adressen der Variablen zu arbeiten (Pointer). Alle vDSP Funktionen sind c-artig implementiert. Sie nehmen die Adresse einer Variable entgegen, manipulieren den Wert und geben *keinen* Wert zurück (*side effect*).

Um im Kontext einer modernen, multiparadigmen Programmiersprache mit solch einer Art von Funktionen zu arbeiten, wird die Benutzung der vDSP API mithilfe von geeigneten Datenstrukturen und Funktionen abstrahiert. Zunächst werden die Datenstrukturen vorgestellt. Im übernächsten Kapitel (Operationen auf komplexen Zahlen) werden die Funktionen vorgestellt.

    struct Complex<T> {
        var real: T
        var imag: T
    }

    struct SplitComplexVector<T> {
        var real: [T]
        var imag: [T]
        
        init(real: [T], imag: [T] ) {
            self.real = real
            self.imag = imag
        }
        
        init( count: Int, repeatedValue: Complex<T> ) {
            self.real = [T]( count: count, repeatedValue: repeatedValue.real )
            self.imag = [T]( count: count, repeatedValue: repeatedValue.imag )
        }
        
        subscript(i: Int) -> Complex<T> {
            return Complex<T>(real: real[i], imag: imag[i]);
        }
        
        var count: Int { return real.count }
    }

Als erstes wird die Struktur einer komplexen Zahl beschrieben, welche aus einer realen und einer imaginären Zahl besteht. Der Typ *T* kann wahlweise *Double* oder *Float* sein. Ein *SplitComplexVector* beschreibt eine Menge von komplexen Zahlen, wobei der reale und imaginäre Anteile getrennt betrachtet werden. Des Weiteren wird der Zugriff auf den SplitComplexVector mithilfe des Subscripts vereinfacht:
*/
let vector = SplitComplexVector<Float>(count: 10, repeatedValue: Complex<Float>(real: 0, imag: 0))
let first = vector[0] // subscript, element an der Stelle 0
/*:
#### Die FFT Klasse

Gemäß den oben genannten Anforderungen muss die FFT Implementierung eine Hin- und Rücktransformation ermöglichen:

    protocol Transformation {
        
        func forward() -> SplitComplexVector<Float>
        
        func inverse(x: SplitComplexVector<Float>) -> [Float]
    }

Das Protocol definiert die Transformationen von **real -> forward -> complex -> inverse -> real**. Der Eingabeparameter (real) sind die Samples als Array vom Typ Float. Die Forward-Funktion gibt einen SplitComplexVector vom Typ Float zurück, welcher als Eingabeparameter für die Inverse-Funktion verwendet wird, welche wiederum Samples als Float Array zurückgibt. Die komplexen Zahlen zwischen Forward und Inverse werden für Manipulationen am Signal verwendet, welches im übernächsten Kapitel (Strategien zum Manipulieren der Magnitudes) beschrieben wird.

Die [vDSP API](https://developer.apple.com/library/mac/documentation/Performance/Conceptual/vDSP_Programming_Guide/UsingFourierTransforms/UsingFourierTransforms.html#//apple_ref/doc/uid/TP40005147-CH3-SW1) von Apple benötigt für die FFT ein FFT-Setup und einige Konstanten. Die notwendigen Parameter werden für die aufrufende Instanz über den Konstruktor abstrahiert. Der Konstruktor selbst benötigt lediglich die Samples als Float Array:

    class FFT {
        
        private let setup: FFTSetup
        private let length: Int
        private let samples: [Float]

        init(initWithSamples samples: [Float]) {
            self.samples = samples
            self.length = samples.count
            self.setup = vDSP_create_fftsetup(vDSP_Length(log2(CDouble(length))), FFTRadix(kFFTRadix2))
        }
        
        func destroyFFTSetup() {
            vDSP_destroy_fftsetup(setup)
        }
    }

Die beiden Transformationsfunktionen werden implementiert, indem die Klasse FFT um das Transformation-Protocol erweitert wird :

    extension FFT: Transformation {
        
        func forward() -> SplitComplexVector<Float> {
            var splitComplex = SplitComplexVector<Float>(count: length / 2, repeatedValue: Complex<Float>(real: 0, imag: 0))
            var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
            
            samples.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
                let xAsComplex = UnsafePointer<DSPComplex>( xPointer.baseAddress )
                vDSP_ctoz(xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count))
                vDSP_fft_zrip(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(length))), FFTDirection(FFT_FORWARD))
            }
            
            return splitComplex
        }
        
        func inverse(x: SplitComplexVector<Float>) -> [Float] {
            var splitComplex = x
            var result = [Float](count: length, repeatedValue: 0)
            var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
            
            result.withUnsafeBufferPointer { (resultPointer: UnsafeBufferPointer<Float>) -> Void in
                let resultAsComplex = UnsafeMutablePointer<DSPComplex>( resultPointer.baseAddress )
                vDSP_fft_zrip(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(length))), FFTDirection(kFFTDirection_Inverse))
                vDSP_ztoc(&dspSplitComplex, 1, resultAsComplex, 2, vDSP_Length(splitComplex.count))
            }
            
            vDSP_vsmul(result, 1, [0.5/Float(length)], &result, 1, vDSP_Length(length))
            
            return result
        }
    }

Die Forward-Funktion erzeugt sich zunächst einen *SplitComplexVector* mit der Größe von *Samples/2*, weil die FFT aus *N* Samples ein N/2 großes Array erzeugt, da die Hälfte Redundant ist. Der SplitComplexVector wird mit komplexen Zahlen, 0+0i, aufgefüllt und anschließend als Pointer an den *DSPSplitComplex* übergeben, welcher von der vDSP API als Quelle der FFT Daten verwendet wird. Um die Werte aus den Samples in den DSPSplitComplex zu kopieren, wird die vDSP-Funktion *vDSP_ctoz* verwendet. Da alle vDSP-Funktionen mit Pointern und Adressen arbeiten, muss mithilfe der *withUnsafeBufferPointer*-Funktion die Adresse der Samples ausgelesen und als *UnsafePointer* vom Typ *<DSPComplex>* der eigentlichen *vDSP_ctoz*-Funktion übergeben werden. Auf diese Weise wird die Adresse des aktuellen Samples als *xAsComplex* übergeben und dessen dereferenzierter Wert in den Pointer von *dspSplitComplex* geschrieben. Die letzte Zeile der Closure führt die eigentliche FFT aus. vDSP sieht insgesamt 12 Funktionen für die Fourier Transformation vor, welche sich beispielsweise darin unterscheiden, ob eine 1D oder 2D Transformation durchgeführt werden soll. Des Weiteren wird unterschieden, ob das Ergebnis In-Place oder Out-of-Place und als Float oder Double zurückgegeben werden soll. Aufgrund der zuvor definierten Anforderungen an die FFT, wird die *vDSP_fft_zrip*-Funktion verwendet, welche eine In-Place Transformation mit einfacher Präzision (Float) durchgeführt. Als Parameter werden das in der Init erstellte FFT-Setup, die Adresse von *dspSplitComplex*, die Länge und die Richtung (Forward oder Inverse) übergeben. Die *vDSP_fft_zrip*-Funktion modifiziert die *dspSplitComplex* Variable mit dem Ergebnis der FFT (side effect). Da sowohl der reale als auch der imaginäre Anteil von DSPSplitComplex mit der Adresse von SplitComplexVector initialisiert wurde, gibt die Forward-Funktion nicht den Datentyp von vDSP (DSPSplitComplex), sondern das selbst geschriebene Hilfstruct (SplitComplexVector) zurück. Auf diese Weise ist die Implementierung der FFT-Klasse nicht abhängig von der vDSP API. Bei Bedarf kann die low-level API ausgewechselt werden, ohne das aufrufende Instanzen, die das Transformation-Protocol verwenden, geändert werden müssen.

Im folgenden wird eine Forward-Transformation mithilfe des Transformation-Protocol am Beispiel einer Sinus-Funktion durchgeführt. Zunächst das Erzeugen der Sinus-Funktion: */
import Accelerate

private func sin(x: [Float]) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vvsinf(&results, x, [Int32(x.count)])
    
    return results
}

let count = 64
let frequency: Float = 4.0
let amplitude: Float = 3.0

let sineValues = (0..<count).map { Float(2.0 * M_PI) / Float(count) * Float($0) * frequency }
let samples: [Float] = sin(sineValues)

samples.map{ $0 }
/*:
Mithilfe der Map-Funktion wird eine Sinus-Funktion mit 64 Samples erzeugt und anschließend gezeichnet. Die Samples sollen nun als Basis für die FFT-Forward-Funktion verwendet werden. Das Ergebnis wird ebenfalls gezeichnet:
*/
private func magnitudes( var x: SplitComplexVector<Float> ) -> [Float] {
    var magnitudes = [Float]( count: x.count, repeatedValue: 0 )
    
    let dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )
    
    for i in 0..<x.count {
        magnitudes[i] = sqrt(dspSplitComplex.realp[i] * dspSplitComplex.realp[i] + dspSplitComplex.imagp[i] * dspSplitComplex.imagp[i])
    }
    
    return magnitudes
}

let fft = FFT(initWithSamples: samples)
let forward = fft.forward()

magnitudes(forward).map{ $0 }
/*:
Die Funktion *magnitudes<A, B>(A) -> B* ist eine Hilfsfunktion, die erst im nächsten Unterkapitel besprochen werden. Sie wird benötigt, um die Magnitudes aus den komplexen Zahlen zu extrahieren, die anschließend gezeichnet wurden. Im Folgenden sollen die komplexen Zahlen mithilfe der Inverse-Funktion wieder in das Ausgangssignal zurückgerechnet und anschließend gezeichnet werden: */
let inverse = fft.inverse(forward)

inverse.map{ $0 }
/*:
#### Operationen auf komplexen Zahlen
Wie die Magnitudes-Funktion gezeigt hat, werden einige weitere Funktionen benötigt, welche auf den Daten der FFT operieren. Da die meisten dieser Funktionen intern die Funktionen der vDSP API verwenden, um beispielsweise aus komplexen Zahlen (DSPSplitComplex) Polarkorrdinaten zu extrahieren, wurden die Funktionen wiederum in Swift Funktionen gewrapped. Die Swift Funktionen haben meistens eine Signatur von *func<A>(SplitComplexVector<A>) -> Array<A>*, um erneut nicht von der vDSP API abhängig zu sein. Auch hier kann die Bibliothek für die digitale Signalverarbeitung ausgetauscht werden, ohne das Änderungen bei der aufrufenden Instanz durchgeführt werden müssen.

Neben der Magnitudes-Funktion werden noch einge wichtige Funktionen vorgestellt: */
func normalizedMagnitudes(var x: SplitComplexVector<Float>) -> [Float] {
    var dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )
    
    var magnitudes = [Float](count: x.count, repeatedValue: 0.0)
    vDSP_zvmags(&dspSplitComplex, 1, &magnitudes, 1, vDSP_Length(x.count))
    
    var normalizedMagnitudes = [Float](count: x.count, repeatedValue: 0.0)
    vDSP_vsmul(sqrt(magnitudes), 1, [2.0 / Float(x.count * 2)], &normalizedMagnitudes, 1, vDSP_Length(x.count))
    
    return normalizedMagnitudes
}

func abs(var x: SplitComplexVector<Float> ) -> [Float] {
    var result = [Float]( count: x.count, repeatedValue: 0 )
    
    var dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )
    vDSP_zvabs( &dspSplitComplex, 1, &result, 1, vDSP_Length(x.count) )
    
    return result
}

func polarCoordinates(var x: SplitComplexVector<Float>) -> (mag: [Float], phase: [Float]) {
    var dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )
    
    var magnitudes = [Float](count: x.count, repeatedValue: 0.0)
    var phase = [Float](count: x.count, repeatedValue: 0.0)
    
    vDSP_zvabs(&dspSplitComplex, 1, &magnitudes, 1, vDSP_Length(x.count))
    vDSP_zvphas(&dspSplitComplex, 1, &phase, 1, vDSP_Length(x.count))
    
    return (magnitudes, phase)
}

let polar = polarCoordinates(forward)
polar.mag.map{ $0 }
polar.phase.map{ $0 }

func maxHz(samples: [Float], rate: Int) -> Float {
    let length = samples.count / 2
    
    var max: Float = 0.0
    var maxIndex = vDSP_Length(0)
    vDSP_maxvi(samples, 1, &max, &maxIndex, vDSP_Length(length));
    
    return (Float(maxIndex) / Float(length)) * (Float(rate) / 2)
}

maxHz(samples, rate: count)
/*:
Die erste Funktion, *normalizedMagnitudes<A, b>(A) -> B*, berechnet die Magnitudes einer komplexen Zahl *A* mithilfe der *vDSP_zvmagsD*-Funktion, im Gegensatz zur bereits vorgestellten *magnitudes<A, B>(A) -> B*-Funktion, welche ohne die vDSP API auskommt. Des Weiteren werden die Magnitudes normalisiert, weil *vDSP_zvmags* die quadrierten Magnitudes des komplexen Vektors zurückgibt. Auch die Funktion *abs<A, B>(A) -> B* macht letztlich das Gleiche wie *magnitudes* und *normalizedMagnitudes*, außer das Normalisieren. Eine neue Funktion ist *polarCoordinates<A, B>(A) -> (B, B)*, welche die Polarkoordinaten als Tupel zurückgibt. Hierbei beschreiben Magnitudes den Abstand zu 0 und Phase den Winkel zur Koordinate. Zuletzt sei noch die Funktion *maxHz<A, B, C>(A, B) -> C* erwähnt, welche die Frequenz der übergebenen Samples *A* unter Berücksichtigung der Samplingrate *B* mithilfe der *vDSP_maxvi*-Funktion berechnet. Die Funktion wird am Beispiel der Sinus-Funktion aufgerufen und gibt die Frequenz 4 zurück. Angesichts der Zeile *let frequency: Float = 4.0* stimmt das Ergebnis.

#### Strategien zum Manipulieren der Magnitudes

Bislang verfügt die FFT-Klasse lediglich über die Funktion der Hin- und Rücktransformation. Allerdings wird eine Implementierung benötigt, die eine Manipulation des Signales ermöglicht. Genauer gesagt müssen zwischen der Forward- und Inverse-Funktion die Magnitudes aus den komplexen Zahlen extrahiert, manipuliert und anschließend wieder als komplexe Zahlen zurückgegeben werden. Demnach hat die Funktion eine Signatur von *apply<A>(A) -> A*, wobei A vom Typ *Array(Float)* oder *Array(Double)* sein sollte.

Um mehrere Strategien für das Manipulieren von Daten zu ermöglichen und diese dynamisch zur Laufzeit hinzufügen zu können, wird ein *FilterStrategy*-Protocol mit der oben genannten Funktions-Signatur deklariert. Des Weiteren wird ein *Filterable*-Protocol definiert, welcher der FFT-Klasse ermöglicht, eine Array von Filter-Strategien zu setzen, um mehrere Strategien funktional zu komponieren. Hierbei liegen alle Implementierungen von FilterStrategy als *Strategy-Pattern* vor. Die modulare Implementierung der FFT-Klasse erlaubt ein dynamisches Hinzufügen und Komponieren der Strategien. Auf die Weise kann beispielsweise erst eine *Noise-Reduction* erfolgen, bevore das Signal in einen bestimmten Frequenzbereich gemaped wird. Selbst diese beiden Implementierungen können durch einen verbesserten Noise-Reduction- oder Mapping-Algorithmus ausgetauscht werden.

    protocol FilterStrategy {
        
        func apply(x: [Float]) -> [Float]
    }

    protocol Filterable {
        
        var strategy: [FilterStrategy] { get set }
    }

    extension FFT: Filterable {
        
        var strategy: [FilterStrategy]
        
        convenience init(initWithSamples samples: [Float], andStrategy strategy: [FilterStrategy]) {
            self.init(initWithSamples: samples)
            self.strategy = strategy
        }
    }

Über einen weiteren Konstruktur wird ein Array von *FilterStrategy* übergeben. Als nächstes folgt die Implementierung der Funktion, welche die Magnitudes auf den komplexen Zahlen extrahiert und die *apply-Funktion* aller Filter-Strategies komponiert. Die Funktion setzt bei *complex* zwischen *forward -> complex* und *complex -> inverse* an und hat demnach eine Signatur von *A -> A* wobei A ein SplitComplexVector vom Typ Float ist.

    extension FFT {
        
        func applyStrategy(x: SplitComplexVector<Float>) -> SplitComplexVector<Float> {
            var splitComplex = x
            let result = [Float](count: length, repeatedValue: 0)
            var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
            
            result.withUnsafeBufferPointer { (resultPointer: UnsafeBufferPointer<Float>) -> Void in
                let resultAsComplex = UnsafeMutablePointer<DSPComplex>( resultPointer.baseAddress )
                vDSP_ztoc(&dspSplitComplex, 1, resultAsComplex, 2, vDSP_Length(splitComplex.count))
            }
            
            let applied = strategy.reduce(result) { $1.apply($0) } // composing strategies
            
            applied.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
                let xAsComplex = UnsafePointer<DSPComplex>( xPointer.baseAddress )
                vDSP_ctoz(xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count))
            }
            
            return splitComplex
        }
    }

Vor und nach dem Anwenden der Strategien müssen die komplexen Zahlen, ähnlich wie bei der Forward- und Inverse-Funktion, zunächst mithilfe der *withUnsafeBufferPointer*-Funktion extrahiert, aufbereitet und als *DSPSplitComplex* zurückgegeben werden. Das eigentliche Anwenden der Strategien erfolgt mithilfe der funktionalen Reduce-Funktion. Diese wird (über Umwegen) mit den Werten des Übergabeparameters *x*, den Magnitudes der komplexen Zahlen aus der Forward-Funktion, intialisiert. Basierend auf diesem Startwert wird für jede Strategy *$1* die *apply* Funktion mit dem Ergebnis des vorherigen Durchlaufs *$0* aufgerufen. Auf diese Weise werden alle Strategien komponiert und das Ergebnis mithilfe der *withUnsafeBufferPointer*-Funktion als *SplitComplexVector* vom Typ Float zurückgegeben.

Im Folgenden wird ein Workflow für das Manipulieren des oben definierten Sinus-Signals beschrieben. Hierfür wird eine Double-, Tripple und eine No-Strategy als Implementierung von FilterStrategy verwendet, um die Komposition der Strategien zu testen. 

    class NoStrategy: FilterStrategy {
        func apply(x: [Float]) -> [Float] {
            return x
        }
    }

    class DoubleStrategy: FilterStrategy {
        func apply(x: [Float]) -> [Float] {
            return x.map { $0 * 2 }
        }
    }

    class TrippleStrategy: FilterStrategy {
        func apply(x: [Float]) -> [Float] {
            return x.map { $0 * 3 }
        }
    }

*/
let withStrategies = FFT(initWithSamples: samples, andStrategy: [DoubleStrategy(), NoStrategy(), TrippleStrategy()])
let forardWithS = withStrategies.forward()
let applied = withStrategies.applyStrategy(forardWithS)
let inverseWithS = withStrategies.inverse(applied)

inverseWithS.map{$0}
max(samples)
max(inverseWithS)
/*: Auch wenn die oben gezeichnete modifizierte Sinus-Funktion sich opisch nicht von der am Anfang gezeigten Sinus-Funktion unterscheidet, ist das Entscheidende der *max*-Funktion zu entnehmen. Während der höchste Wert der originalen Sinus-Samples 1 beträgt, ist es bei dem modifizierten Signal eine 6, weil 1 (original) * 2 (DoubleStrategy) * 3 (TrippleStrategy) = 6 ergibt. 

Um den Aufruf von *forward -> apply -> inverse* etwas angenehmer zu gestalten, wurde ein überladener inflix Operator *-->* eingeführt, welcher das Ergebnis von *Left* als Übergabeparameter von *Right* komponiert. Demnach können die folgenden zwei Signaturen aufreten

* --><A, B>(A, A -> B) -> B und 
* --><A>(A, A -> A) -> A

auftreten, weil die Überführung entweder von *Array<Float>* zu *Array<Float>*, *SplitComplexVector<Float>* zu *SplitComplexVector<Float>* oder von *SplitComplexVector<Float>* zu *Array<Float>* erfolgt. Intern wird das Ergebnis von Links der Funktion von Rechts übergeben und dessen Ergebnis als nächstes Links zurückgegeben: 

    infix operator --> { associativity left }

    func --><A, B>(left: A, right: A -> B) -> B {
        return right(left)
    }

    func --><A>(left: A, right: A -> A) -> A {
        return right(left)
    }
*/

let overload = FFT(initWithSamples: samples, andStrategy: [DoubleStrategy(), NoStrategy(), TrippleStrategy()])
let composed = overload.forward() --> overload.inverse

composed.map{ $0 }
/*: Die modulare Implementierung der FFT-Klasse und dem Strategy-Pattern erlaubt das Hinzufügen von Strategien, die von der FFT berücksichtigt werden. Im Rahmen des Prototypen wurden die Algorithmen zu den Mapping- und Noise-Reduction-Strategien aufgrund von gegebenen Ressourcen naiv implementiert. Sie führen zwar zu einem Ergebnis, allerdings sind noch einige naiven Annahmen drin, die nicht zum besten Ergebnis führen. Das intensive Auseinandersetzen mit angemessenen Audio-Algorithmen würde zu viel Zeit in Anspruch nehmen, da die theoretischen Hintergründe fundierter betrachtet werden müssen. Es lässt sich wahrscheinlich ein eigenes Guided-Project formulieren, welches einzig und allein diese Thematik behandelt. Aus diesem Grund werden lediglich die naiven Algorithmen von Noise-Reduction und Mapping-Strategien besprochen. Afugrund der modularen Implementierung der FFT-Klasse können zu einem späteren Zeitpunkt die Implementierungen erweitert und durch bessere Algorithmen ausgetauscht werden.

#### Noise-Reduction- und Mapping-Strategien

** Das musst du wahrscheinlich machen, oder wir zusammen. Hier müssen auch unsere Herleitungen, Überlegungen und Gedanken usw. rein. **

### Modifizierte Samples als Audio-Datei abspielen

**Das musst du machen**

## Beispiel anhand eines Anwendungsfalls

In diesem Kapitel soll die FFT-Pipeline anhand einer realen Test-Audiodatei durchlaufen werden. Dabei werden die folgenden Aktivitäten durchgeführt:

* Extrahieren von Samples aus der Audio-Datei
* Manipulation der Samples mithilfe der FFT
* Modifizierte Samples als neue Audio-Datei abspeichern

Aus Gründen der Performanz werden nur die ersten 2048 Samples der Audiodatei betrachtet. Ansonsten würde das Playground zu lange rechnen, um die Ergebnisse anzuzeigen.

Als Erstes werden die Samples aus der Autodatei mithilfe der AudioFile-Klasse extrahiert. Außerdem werden weitere Variablen wie Samplingrate und Bin-Größe initialisiert: */
import AVFoundation

let audioFile = AudioFile()
let filename = "/alex.m4a"

let data = Array(audioFile.readAudioFileToFloatArray(NSBundle.mainBundle().bundlePath.stringByAppendingString(filename))![0..<(1024*2) + (800)])

data.count
data.map{ $0}

let samplingRate = 44100
let n = 1024
let length = n / 2
/*:
Im Playground ist die Verwendung des Hörtests nicht möglicht. Deshalb werden die minimale und maximale hörbare Frequenz hartkodiert eingetragen. Allerdings handelt es sich hierbei um den tatsächlichen Frequenzbereichs von einem der beiden Projektpartnern. Der Frequenzbereich muss nun noch einen Index abgebildet werden, um die entsprechenden Frequenzen identizieren zu können: */
let maxFrequency = 13000
let minFrequency = 0

let maxIndex = (length * Int(maxFrequency)) / (samplingRate / 2 )
let minIndex = (length * Int(minFrequency)) / (samplingRate / 2 )
/*:
Als nächstes werden die Samples mit Nullen aufgefüllt, um ohne Verluste in *n=1024* Größe Unter-Arrays aufgeteilt zu werden. Auf diese Weise wird die FFT jeweils für 1024 Samples durchgeführt, um **HIER DEN GRUND DAFÜR**. Des Weiteren werden die Samples mithilfe einer Window-Funktion skaliert, um **HIER DEN GRUND DAFÜR**: */
let padded = addZeroPadding(data, whileModulo: n)
padded.map{ $0 }
let window: [Float] = hamming(padded.count)
window.map{ $0 }
let windowedData = window * padded
windowedData.map{ $0 }
let prepared = prepare(windowedData, steppingBy: n)
/*:
Nachdem alle Vorbereitungen getroffen worden sind, folgt die eigentlich FFT. *prepared* ist vom Typ Array<Array<Float>>, da die Samples (Array<Float>) wiederum in 1024 Sample große Unter-Arrays aufgeteilt wurden. Um an jedes Unter-Array zu gelangen, diese in eine FFT zu geben und das Ergebnis wieder zu einem einzigen Array vom Typ Float zu agregieren, wird im Folgenden eine Kombination von *flatMap* und *compose* verwendet: */
let result = prepared.flatMap { samples -> [Float] in
    let fft = FFT(initWithSamples: samples, andStrategy: [
        NoiseReductionStrategy(),
        AverageMappingStrategy(minIndex: minIndex, andMaxIndex: maxIndex)]
    )
    
    let f = fft.forward()
    magnitudes(f).map{ $0 }
    
    let a = f --> fft.applyStrategy
    magnitudes(a).map{ $0 }
    
    return a --> fft.inverse
}

let unwindowed = result / window
unwindowed.map{ $0 }
/*:
Durch *flatMap* ist *result* vom Typ Array<Float>, also unsere mit *NoiseReduction* und *AverageMappingStrategy* modifizierten Samples. Diese müssen nur noch als Audiodatei rekonstruiert und unter einer neuen Datei gespeichert werden: */
let path = audioFile.safeSamples(result, ToPath: NSBundle.mainBundle().bundlePath.stringByAppendingString("/blaalex.m4a"))
/*:
## Abschluss

### Zusammenfassung und Fazit
### Persönliche Einschätzung und kritische Reflexion
### Ausblick
*/
