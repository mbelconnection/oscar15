-- MySQL dump 9.07
--
-- Host: localhost    Database: oscar_mcmaster
---------------------------------------------------------
-- Server version	4.0.12-standard

--
-- Dumping data for table 'FaxClientLog'
--

--
-- Dumping data for table 'allergies'
--

--
-- Dumping data for table 'billactivity'
--

--
-- Dumping data for table 'billing'
--

--
-- Dumping data for table 'billingdetail'
--

--
-- Dumping data for table 'billinginr'
--
--
-- Dumping data for table 'billingservice'
--

--
-- Dumping data for table 'consultationRequests'
--

--
-- Dumping data for table 'consultationServices'
--

INSERT INTO consultationServices VALUES (53,'Cardiologia','1');
INSERT INTO consultationServices VALUES (54,'Dermatologia','1');
INSERT INTO consultationServices VALUES (55,'Neurologia','1');
INSERT INTO consultationServices VALUES (56,'Radiologia','1');
INSERT INTO consultationServices VALUES (57,'Veja anota��es','1');

--
-- Dumping data for table 'ctl_billingservice'
--

--
-- Dumping data for table 'ctl_billingservice_premium'
--

--
-- Dumping data for table 'ctl_diagcode'
--


--
-- Dumping data for table 'ctl_doctype'
--

INSERT INTO ctl_doctype VALUES ('demographic','lab','A');
INSERT INTO ctl_doctype VALUES ('demographic','consult','A');
INSERT INTO ctl_doctype VALUES ('demographic','insurance','A');
INSERT INTO ctl_doctype VALUES ('demographic','legal','A');
INSERT INTO ctl_doctype VALUES ('demographic','oldchart','A');
INSERT INTO ctl_doctype VALUES ('demographic','others','A');
INSERT INTO ctl_doctype VALUES ('provider','resource','A');
INSERT INTO ctl_doctype VALUES ('provider','desktop','A');
INSERT INTO ctl_doctype VALUES ('provider','handout','A');
INSERT INTO ctl_doctype VALUES ('provider','forms','A');
INSERT INTO ctl_doctype VALUES ('provider','others','A');
INSERT INTO ctl_doctype VALUES ('provider','share','A');

--
-- Dumping data for table 'ctl_document'
--

INSERT INTO ctl_document VALUES ('provider',999998,4953,'A');
INSERT INTO ctl_document VALUES ('provider',999998,4954,'H');
INSERT INTO ctl_document VALUES ('demographic',2147483647,4955,'A');

--
-- Dumping data for table 'ctl_frequency'
--


--
-- Dumping data for table 'ctl_provider'
--

--
-- Dumping data for table 'ctl_specialinstructions'
--

--
-- Dumping data for table 'demographic'
--

--
-- Dumping data for table 'demographicaccessory'
--


--
-- Dumping data for table 'demographiccust'
--


--
-- Dumping data for table 'demographicstudy'
--


--
-- Dumping data for table 'desannualreviewplan'
--


--
-- Dumping data for table 'desaprisk'
--


--
-- Dumping data for table 'diagnosticcode'
--


--
-- Dumping data for table 'diseases'
--


--
-- Dumping data for table 'document'
--

--
-- Dumping data for table 'drugs'
--


--
-- Dumping data for table 'dxresearch'
--


--
-- Dumping data for table 'eChart'
--


--
-- Dumping data for table 'eform'
--


--
-- Dumping data for table 'eform_data'
--


--
-- Dumping data for table 'eforms'
--


--
-- Dumping data for table 'eforms_data'
--


--
-- Dumping data for table 'encounter'
--


--
-- Dumping data for table 'encounterForm'
--

INSERT INTO encounterForm VALUES ('Annual','formAnnual.jsp?demographic_no=','formAnnual');
INSERT INTO encounterForm VALUES ('ALPHA','formAlpha.jsp?demographic_no=','formAlpha');
INSERT INTO encounterForm VALUES ('Rourke','formRourke.jsp?demographic_no=','formRourke');
INSERT INTO encounterForm VALUES ('T2Diabetes','formType2Diabetes.jsp?demographic_no=','formType2Diabetes');
INSERT INTO encounterForm VALUES ('Mental Health','formMentalHealth.jsp?demographic_no=','formMentalHealth');
INSERT INTO encounterForm VALUES ('PeriMenopausal','formPeriMenopausal.jsp?demographic_no=','formPeriMenopausal');
INSERT INTO encounterForm VALUES ('Lab Req','formLabReq.jsp?demographic_no=','formLabReq');
INSERT INTO encounterForm VALUES ('MMSE','formMMSE.jsp?demographic_no=','formMMSE');
INSERT INTO encounterForm VALUES ('Pall. Care','formPalliativeCare.jsp?demographic_no=','formPalliativeCare');
INSERT INTO encounterForm VALUES ('AR','formAR.jsp?demographic_no=','formAR');

--
-- Dumping data for table 'encountertemplate'
--


INSERT INTO encountertemplate VALUES ('SOAP','0001-01-01 00:00:00','');
INSERT INTO encountertemplate VALUES ('C�lica biliar','0001-01-01 00:00:00','Subjetivo:\r\nObjetivo:\r\nAn�lise:\r\nPlano:\r\n');
INSERT INTO encountertemplate VALUES ('Enfisema pulmonar','0001-01-01 00:00:00','1. interrogat�rio sobre pelo menos 3 dos seguintes:\r\ndor, descri��o\r\nE\r\nlocaliza��o\r\nintoler�ncia alimentar\r\nrecorr�ncia\r\nfebre\r\n2. Exame abdominal?\r\n3. Exame do T�rax?\r\n4. Freq��ncia card�aca e ritmo?\r\n5. Press�o arterial?\r\n6. Hemograma?\r\n7. TGO, bilirrubinas s�ricas e fosfatase alcalina?\r\n8. RX ou ultrassom da ves�cula biliar\r\n9. Orienta��o sobre baixa ingesta de alimentos gordurosos\r\n10. Retorno dentro de 1 m�s?\r\n11. SE recorrente');
INSERT INTO encountertemplate VALUES ('otite externa','0001-01-01 00:00:00','1. Interrogat�rio sobre sintomas tor�cicos na consulta, pelo menos 2 dos seguintes:\r\ntosse\r\nexpectora��o\r\nsibilos\r\ndispn�ia\r\n2. Exame Cardio-pulmonar pelo menos uma vez em dois anos?\r\n3. Eletrocardiograma no prontu�rio');
INSERT INTO encountertemplate VALUES ('IVAS','0001-01-01 00:00:00','1. Interrogat�rio sobre sintomas?\r\n2. Otoscopia?\r\n3. Evid�ncias de "membrana timp�nica normal"?');
INSERT INTO encountertemplate VALUES ('gripe','0001-01-01 00:00:00','1. Queixa de pelo menos um dos seguintes?\r\ndescarga nasal\r\ninflama��o da garganta\r\nastenia\r\nfrio\r\n2. Dura��o dos sintomas?\r\n3. SE existir tosse na hist�ria, exame do t�rax?\r\n4. SE paciente\r\n5. SE existir dor de garganta na hist�ria, oroscopia?\r\n6. SE antituss�genos prescritos, h� tosse na hist�ria?\r\n7. SE antibi�ticos prescritos, h� hist�ria de infec��o secund�ria?');
INSERT INTO encountertemplate VALUES ('�lcera p�ptica','0001-01-01 00:00:00','1. Interrogat�rio sobre 3 dos seguintes:\r\nmialgia\r\nfebre\r\ntosse\r\ntipo de secre��o\r\nastenia\r\n2. Interrogat�rio sobre dura��o dos sintomas?\r\n3. Exame de ouvido, nariz e garganta?\r\n4. SE tosse, ausculta pulmonar?\r\n5. SE antibi�ticos prescritos, h� hist�ria de infec��o secund�ria?');
INSERT INTO encountertemplate VALUES ('rea��o al�rgica','0001-01-01 00:00:00','1. Interrogat�rio sobre dor epig�strica?\r\n2. Interrogat�rio sobre hist�ria de sintomas semelhantes?\r\n3. Interrogat�rio sobre al�vio dos sintomas com anti�cidos ou leite?\r\n4. Exame abdominal?\r\n5. Esofagogastroduodenografia\r\nOU\r\nendoscopia digestiva alta feita?\r\n6.Esofagogastroduodenografia\r\nOU\r\nendoscopia demonstrando les�o ulcerosa?\r\nE/OU em cicatriza��o?\r\n7. SE �lcera g�strica demonstrada no D1248\r\nOU\r\nna endoscopia, procedimento repetido dentro de 6 semanas?\r\n8. Instru��o sobre dieta?\r\n9. SE tabagista, aconselhamento sobre o fumo?\r\n10. Instru��o sobre bebidas alco�licas?\r\n11. Aconselhamento sobre fatores estressantes?\r\n12. H� uso de alguma das seguintes drogas:\r\nesteroides orais\r\nanti-inflamat�rios n�o esteroidais\r\nAAS\r\ncolchicina\r\n13. Retorno pelo menos de 6/6 semanas at� paciente assintom�tico\r\nOU\r\nCura/cicatriza��o demonstrada pelo esofagograma seriado\r\nOU\r\npela endoscopia?');
INSERT INTO encountertemplate VALUES ('traumatismo cr�nio-encef�lico','0001-01-01 00:00:00','1. Interrogat�rio sobre tipo OU descri��o da rea��o?\r\n2. Interrogat�rio sobre localizac�o da rea��o?\r\n3. Interrogat�rio sobre gravidade da rea��o?\r\n4. Interrogat�rio sobre poss�veis causas?');
INSERT INTO encountertemplate VALUES ('orquite e epididimite','0001-01-01 00:00:00','Estas quest�es s�o aplicadas apenas para\r\no primeiro atendimento do TCE\r\n1. Descri��o da les�o?\r\n2. N�vel de consci�ncia desde a ocorr�ncia do trauma?\r\n3. Causa do trauma?\r\n4. Mecanismo do trauma?\r\n5. Exame de cabe�a e pesco�o?\r\n6. Exame de ouvido, nariz e garganta?\r\n7. Nervos cranianos?\r\n8. Exame neurol�gico?\r\n9. Pulso e press�o arterial?\r\n10. N�vel de consci�ncia e orienta��o no momento do exame?\r\n11. SE rebaixamento do n�vel de consci�ncia, RX de cr�nio\r\nOU TC OU encaminhamento?\r\n12. SE dor no pesco�o\r\nOU sensibilidade, RX de coluna cervical?\r\n13. Analg�sicos narc�ticos prescritos?');
INSERT INTO encountertemplate VALUES ('dermatite por fralda','0001-01-01 00:00:00','1. Interrogat�rio sobre localiza��o da dor?\r\n2. Interrogat�rio sobre edema dos test�culos?\r\n3. Exame dos test�culos?\r\n4. Acometimento de sensibilidade?\r\n5. Leucograma?\r\n6. An�lise de Urina?\r\n7. Urocultura?\r\n8. Suporte para o escroto?\r\n9. SE epididimite, antibi�ticos usados?\r\n10. Seantibi�ticos usados, dosagem e dura��o do tratamento?\r\n11. Retorno dentro de uma semana?');
INSERT INTO encountertemplate VALUES ('prostatite cr�nica','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o?\r\n2. Descri��o da les�o/rash ?\r\n3. SE monil�ase, acometimento da boca?\r\n4. SE monil�ase, antif�ngico t�pico usado?\r\n5. Orienta��o sobre higiene na troca das fraldas?\r\n6. SE "grave", retorno dentro de 1 m�s?\r\n7. Ester�ides fluorinados usados?\r\n8. SE monil�ase oral tamb�m presente, uso de antif�ngicos orais?');
INSERT INTO encountertemplate VALUES ('dismenorr�ia','0001-01-01 00:00:00','1. Interrogat�rio sobre pelo menos 3 dos seguintes?\r\ndis�ria\r\nfreq��ncia\r\ndor perineal\r\ndispareunia\r\nsecre��o uretral\r\ndor lombar\r\nnict�ria\r\n2. Exame abdominal?\r\n3. Toque retal?\r\n4. Descri��o da pr�stata');
INSERT INTO encountertemplate VALUES ('ITU','0001-01-01 00:00:00','1. Hist�ria menstrual?\r\n2. Interrogat�rio sobre sintomas urin�rios?\r\n3. Interrogat�rio sobre per�odos da dor?\r\n4. SE sexualmente ativa, exame p�lvico com dor � mobiliza��o do colo?\r\n5. Exame abdominal?\r\n6. SE presen�a de secre��o vaginal, urocultura?\r\n7. Retorno dentro de 4 meses?');
INSERT INTO encountertemplate VALUES ('les�o no joelho','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o dos sintomas?\r\n2. Interrogat�rio sobre primeiro epis�dio ou epis�dios recorrentes?\r\n3. Interrogat�rio sobre pelo menos 2 dos seguintes:\r\nfreq��ncia\r\ndis�ria\r\nhemat�ria\r\nfebre\r\n4. Exame abdominal?\r\n5. Presen�a/aus�ncia de sensibilidade em flanco OU CVA?\r\n6. SE mais de 2 infec��es dentro de 1 ano em mulher, exame vaginal?\r\n7. An�lise de urina AND bacterioscopia?\r\n8. Urocultura?\r\n9. SE tr�s ou mais epis�dios');
INSERT INTO encountertemplate VALUES ('surdez','0001-01-01 00:00:00','1. Descri��o de como a les�o ocorreu?\r\n2. Dura��o do desconforto?\r\n3. Presen�a/aus�ncia de colapso ou limita��o ao movimento?\r\n4. Presen�a ou aus�ncia de tumefa��o?\r\n5. Dor � mobiliza��o?\r\n6. Dor no exame de estabilidade ligamentar?\r\n7. SE derrame persistir por mais de 72 horas, aspira��o ou encaminhamento?\r\n8. SE limita��o do movimento ou instabilidade, encaminhamento?');
INSERT INTO encountertemplate VALUES ('s�filis','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o da perda auditiva?\r\n2. Interrogat�rio sobre trauma ou infec��o ou exposi��o ocupacional');
INSERT INTO encountertemplate VALUES ('h�rnia inguinal','0001-01-01 00:00:00','1. Interrogat�rio sobre exposi��o?\r\n2. SE presen�a de les�es de pele, interrogat�rio sobre dura��o?\r\n3. SE s�filis prim�ria, presen�a/aus�ncia de cancro?\r\n4. SE s�filis secund�ria, presen�a/aus�ncia de rash cut�neo?\r\n5. Presen�a/aus�ncia de linfadenopatia?\r\n6. VDRL ou FTA abs?\r\n7. SE VDRL ou FTA abs negativo, repetir dentro de 2 meses?\r\n8. Swab para cultura e antibiograma para gonorr�ia?\r\n9. SE uso de antibi�ticos, foi penicilina, eritromicina, tetraciclina ou estreptomicina?\r\n10. Notifica��o para as autoridades de sa�de p�blica?\r\n11. Retorno dentro de 2 meses?');
INSERT INTO encountertemplate VALUES ('depress�o','0001-01-01 00:00:00','1. Interrogat�rio sobre presen�a/aus�ncia de v�mitos?\r\n2. Interrogat�rio sobre pelo menos 2 dos seguintes:\r\nabaulamento inguinal\r\ndura��o\r\ndor\r\n3. Descri��o da massa inguinal incluindo o lado?\r\n4. possibilidade ou n�o de redu��o?\r\n5. SE n�o redut�vel E presen�a de dor, encaminhamento para cirurgia dentro de 24 horas?');
INSERT INTO encountertemplate VALUES ('laringite ou traque�te','0001-01-01 00:00:00','1. Interrogat�rio sobre medicamentos/drogas usadas?\r\n2. Interrogat�rio sobre dura��o do problema?\r\n3. Interrogat�rio sobre idea��o suicida ou situa��o leve da depress�o?\r\n4. SE queixas f�sicas, evid�ncias no exame f�sico ?\r\n5. Exame C�rdio-pulmonar dentro de dois anos?\r\n6. Altera��o de humor OU apar�ncia OU afeto?\r\n7. SE prescrito antidepressivo, retorno dentro de 2 semanas?\r\n8. SE primeira prescri��o de antidepressivos, dura��o E\r\n9. SE medica��o n�o prescrita, retorno dentro de 1 m�s?\r\n10. SE idea��o suicida, encaminhamento ou hospitaliza��o?\r\n11. Discuss�o sobre fatores estressantes?\r\n12. Barbit�ricos foram prescritos?');
INSERT INTO encountertemplate VALUES ('gonorr�ia','0001-01-01 00:00:00','1. Dura��o dos sintomas?\r\n2. Presen�a/aus�ncia de tosse?\r\n3. Oroscopia?\r\n4. Ausculta pulmonar?');
INSERT INTO encountertemplate VALUES ('doen�a coronariana','0001-01-01 00:00:00','1. Interrogat�rio sobre tempo desde a exposi��o?\r\n2. Interrogat�rio sobre contatos sexuais?\r\n3. Interrogat�rio sobre sintomas');
INSERT INTO encountertemplate VALUES ('osteoporose','0001-01-01 00:00:00','1. Queixa sobre um dos seguintes em cada consulta?\r\nangina\r\ndispn�ia\r\nedema de tornozelo\r\n2. Qeuixa de dor OU uso de nitroglicerina anualmente?\r\n3. Queixa de intoler�ncia para exerc�cios anualmente? \r\n4. Press�o arterial em cada consulta para este diagn�stico');
INSERT INTO encountertemplate VALUES ('alcoolismo','0001-01-01 00:00:00','\r\n1. Interrogat�rio sobre presen�a/aus�ncia de dor?\r\n2. Interrogat�rio sobre hist�ria diet�tica?\r\n3. Interrogat�rio sobre data da menopausa?\r\n4. SE presen�a de dor, exame da regi�o?\r\n5. Queixa de cifose?\r\n6. RX ou densidometria �ssea OU espessura cortical?\r\n7. Confirma��o de osteoporose por um dos testes da quest�o 6?\r\n8. Aumento da ingesta de c�lcio?');
INSERT INTO encountertemplate VALUES ('lacera��o','0001-01-01 00:00:00','1. Ingesta de �lcool, quantidade por dia?');
INSERT INTO encountertemplate VALUES ('faringite estreptoc�cica','0001-01-01 00:00:00','1. Interrogat�rio sobre como a lacera��o ocorreu?\r\n2. Tempo entre a inj�ria e a consulta?\r\n3. Descri��o do ferimento?\r\n4. SE m�o ou punho, acometimento da fun��o?\r\n5. SE acometimento de tend�es, encaminhamento?\r\n6. Debridamento?');
INSERT INTO encountertemplate VALUES ('otite m�dia serosa','0001-01-01 00:00:00','1. Interrogat�rio sobre inflama��o da garganta?\r\n2. Interrogat�rio sobre presen�a ou aus�ncia de febre?\r\n3. Interrogat�rio sobre tosse?\r\n4. Oroscopia?\r\n5. Presen�a/aus�ncia de linfadenopatia?\r\n6. Presen�a/aus�ncia de exsudato em faringe?\r\n7. SE febre OU linfadenopatia OU exsudato OU hipertrofia de am�gdalas, swab de orofaringe com cultura e antibiograma?\r\n8. Uso de antibi�ticos, foi prescrito penicilina, eritromicina ou cefalosporina?\r\n9. SE uso de antibi�tico, ades�o do paciente por pelo menos 7 dias?\r\n10. Retorno dentro de 2 semanas?\r\n11. SE cultura estreptoc�cica positiva, antibi�ticos usados?');
INSERT INTO encountertemplate VALUES ('hemorr�ida','0001-01-01 00:00:00','1. Interrogat�rio sobre no m�nimo dois dos seguintes: acuidade auditiva, dor, recorr�ncia de infec��es?\r\n2. Queixa de l�quido no ouvido m�dio ou retra��o do t�mpano?\r\n3. Queixa sobre nariz e garganta?\r\n4. SE terceiro epis�dio ou mais, audiometria ou encaminhamento?\r\n5. SE altera��es f�sicas OU testes de audi��o alterados, retorno at� resolu��o do caso ou encaminhamento?');
INSERT INTO encountertemplate VALUES ('mononucleose','0001-01-01 00:00:00','1. Interrogat�rio sobre dor?\r\n2. Interrogat�rio sobre sangramento?\r\n3. Toque retal?\r\n4. SE sangramento retal, retosigmoidoscopia?');
INSERT INTO encountertemplate VALUES ('hipertireoidismo','0001-01-01 00:00:00','1. Interrogat�rio sobre pelo menos 2 dos seguintes:\r\ninflama��o da garganta\r\nfebre\r\nastenia\r\nlinfadenopatia\r\ndor abdominal\r\n2. Presen�a/aus�ncia de febre?\r\n3.Oroscopia?\r\n4. Presen�a/aus�ncia de linfadenopatia?\r\n5. Presen�a/aus�ncia de hepatoesplenomegalia?\r\n6. leucograma e diferenciais?\r\n7. Sorologia para mononucleose?\r\n8. Teste positivo para mono OU altera��o de leucograma?\r\n9. Orienta��o sobre redu��o das atividades?\r\n10. Uso de ampicilina?\r\n11. SE presen�a de esplenomegalia, retorno dentro de 2 semanas?\r\n12. SE aus�ncia de esplenomegalia, retorno dentro de 4 semanas?\r\n13. SE presen�a de esplenomegalia, orienta��o para evitar esportes ou atividades de contato?');
INSERT INTO encountertemplate VALUES ('isquemia cerebral transit�ria','0001-01-01 00:00:00','1. Interrogat�rio sobre um ou mais dos seguintes:\r\nperda de peso, palpita��es\r\ntremores de extremidades, ins�nia\r\nfraqueza muscular\r\nfadiga\r\n2. exame de tire�ide?\r\n3. pulso?\r\n4. Inspe��o dos olhos?\r\n5. T4 OU T3 OU resina de capta��o OU outros testes de tire�ide?\r\n6. T4 E T3 E capta��o elevados?\r\n7. Retorno de 6/6 meses?\r\n8. Eutiroideu dentro de 6 meses ou encaminhamento?');
INSERT INTO encountertemplate VALUES ('impetigo e piodermite','0001-01-01 00:00:00','1. Interrogat�rio sobre freq��ncia?\r\n2. Interrogat�rio sobre dura��o de cada epis�dio?\r\n3. Descri��o dos sintomas?\r\n4. Exame neurol�gico com descri��o do deficit?\r\n5. Press�o arterial?\r\n6. Ausculta cardiovascular?\r\n7. Presen�a/aus�ncia de sopro carot�deo?\r\n8. ECG?\r\n9. SE masculino >55 anos, prescrito AAS como medica��o inicial ou causa identificada?\r\n10. SE uso de AAS, dura��o e dosagem registrados?\r\n11. SE 2 ou mais epis�dios, encaminhamento ou interna��o hospitalar?\r\n12. SE tabagista, aconselhamento sobre o fumo?\r\n13. Retorno dentro de 1 m�s?\r\n14. Causa');
INSERT INTO encountertemplate VALUES ('carcinoma baso e espinocelular','0001-01-01 00:00:00','1. Local de acometimento?\r\n2. SE uso de antibi�tico oral, este era penicilina, eritromicina, sulfonamida, tetraciclina ou cefalosporina?\r\n3. SE tetraciclina usada, era paciente');
INSERT INTO encountertemplate VALUES ('conjuntivite','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o da les�o?\r\n2. Localiza��o da les�o?\r\n3. Tamanho da les�o?\r\n4. Bi�psia e anatomopatol�gico ou encaminhamento?\r\n5. SE n�o foi encaminhado, anatomopatol�gico positivo?\r\n6. Excis�o OU disseca��o OU criocirurgia OU encaminhamento?\r\n7. SE n�o foi encaminhado, retorno dentro de 1 m�s?');
INSERT INTO encountertemplate VALUES ('neuralgia do trig�meo','0001-01-01 00:00:00','1. Interrogat�rio sobre prurido ou secre��o?\r\n2. Interrogat�rio sobre dura��o?\r\n3. Descri��o da conjuntiva?\r\n4. SE ester�ides oft�lmicos usados, a c�rnea foi tingida com col�rio fluorescente?');
INSERT INTO encountertemplate VALUES ('glomerulonefrite','0001-01-01 00:00:00','1. Interrogat�rio sobre gravidade da dor?\r\n2. Interrogat�rio sobre dura��o da dor?\r\n3. Interrogat�rio sobre dor facial?\r\n4. Interrogat�rio sobre fatores desencadeantes?\r\n5. Exame neurol�gico?\r\n6. SE uso de tegretol, exame de fun��o hep�tica dentro de 6 semanas?\r\n7. Orienta��o sobre hist�ria natural da doen�a ou tranquiliza��o?\r\n8. Retorno dentro de 3 meses?');
INSERT INTO encountertemplate VALUES ('aborto espont�neo','0001-01-01 00:00:00','1. Interrogat�rio sobre freq��ncia da urina (olig�ria/an�ria?)\r\n2. Press�o arterial?\r\n3. Peso?\r\n4. An�lise da urina, de rotina E microscopia anualmente?\r\n5. Creatinina anulamente?\r\n6. Ur�ia s�rica anualmente?\r\n7. Clearance de creatinina anualmente?\r\n8. Prote�nas s�ricas anulamente?\r\n9. Hemoglobina anualmente?\r\n10. Um dos seguintes?\r\nproteinemia registrada no prontu�rio\r\ndismorfismo eritrocit�rio\r\nbi�psia renal registrada no prontu�rio\r\n11. Retorno pelo menos anualmente?');
INSERT INTO encountertemplate VALUES ('carcinoma de colo','0001-01-01 00:00:00','1. Data da �ltima menstrua��o?\r\n2. Dura��o da �ltima menstrua��o?\r\n3. Contra��es uterinas presentes?\r\n4. Volume e dura��o do sangramento vaginal?\r\n5. Passagem de tecido?\r\n6. Exame p�lvico e observa��o se colo uterino aberto ou fechado?\r\n7. Press�o arterial?\r\n8.Pulso?\r\n9. Presen�a/aus�ncia de febre?\r\n10. Teste de gravidez?\r\n11. Hemoglobina?\r\n12. Hemat�crito?\r\n13. Fator Rh?\r\n14. SE tecido dispon�vel, amostra encaminhada para laborat�rio?\r\n15. SE indicado pelo fator Rh, imunoglobulina RHOGAM/RH?\r\n16. Retorno dentro de 1 m�s?');
INSERT INTO encountertemplate VALUES ('gravidez ect�pica','0001-01-01 00:00:00','1. Interrogat�rio sobre secre��o vaginal no �ltimo m�s?\r\n2. Interrogat�rio sobre presen�a/aus�ncia de spotting no �ltimo m�s?\r\n3. Descri��o do colo, dentro de um m�s?\r\n4. Exame de Papanicolau positivo?\r\n5. SE classe IV no esfrega�o ou pior, encaminhamento dentro de 1 m�s?');
INSERT INTO encountertemplate VALUES ('vertigem','0001-01-01 00:00:00','1. Interrogat�rio sobre presen�a/aus�ncia de dor abdominal baixa?\r\n2. Interrogat�rio sobre data da �ltima menstrua��o?\r\n3. Interrogat�rio sobre presen�a /aus�ncia de sangramento vaginal?\r\n4. Exame p�lvico?\r\n5. Press�o arterial E pulso?\r\n6. SE secre��o vaginal purulenta, cultura e antibiograma?\r\n7. Exame abdominal?\r\n8. Teste de gravidez?\r\n9. Teste de gravidez negativo, Beta-HCG?\r\n10. SE aus�ncia de encaminhamento ou interna��o, ultrassonografia p�lvica?\r\n11. Teste de gravidez positivo ou Beta-HCG positivo?\r\n12. Encaminhamento ou interna��o?');
INSERT INTO encountertemplate VALUES ('hernia umbilical','0001-01-01 00:00:00','1. Interrogat�rio sobre detalhes do epis�dio?\r\n2. Interrogat�rio sobre dura��o do epis�dio?\r\n3. Interrogat�rio sobre presen�a/aus�ncia de fatores desencadeantes?\r\n4. Interrogat�rio sobre presen�a/aus�ncia de medica��es?\r\n5. Press�o arterial?\r\n6. Freq��ncia card�aca e ritmo?\r\n7. Otoscopia?\r\n8. Rhomberg positivo OU reflexos OU nistagmo?\r\nse uso de diur�ticos, dosagem de eletr�litos?\r\n10. SE o problema persistir, na segunda consulta solicitar glicemia E hemograma?\r\n11. SE arritmia card�aca, ECG OU Holter?\r\n12. SE permanecer por mais de 3 meses e diagn�stico espec�fico realizado, encaminhamento?');
INSERT INTO encountertemplate VALUES ('diabetes melitus ?','0001-01-01 00:00:00','***Paciente abaixo de 1 ano de idade\r\n1. Consultas para orienta��o dos cuidados para o beb�?\r\n2. SE realizado cirurgia, existia indica��o?');
INSERT INTO encountertemplate VALUES ('febre do feno','0001-01-01 00:00:00','1. Interrogat�rio se hist�ria familiar de diabetes?');
INSERT INTO encountertemplate VALUES ('fibromiosite','0001-01-01 00:00:00','1. Interrogat�rio sobre acometimento sazonal?\r\n2. Interrogat�rio sobre fatores desencadeantes?');
INSERT INTO encountertemplate VALUES ('diverticulite','0001-01-01 00:00:00','1. Interrogat�rio sobre dor, descri��o e localiza��o?\r\n2. Interrogat�rio sobre fatores de melhora E/OU piora?\r\n3. Interrogat�rio sobre dura��o?\r\n4. Interrogat�rio sobre o padr�o do sono?\r\n5. Interrogat�rio sobre sintomas de fadiga E/OU poss�vel depress�o?\r\n6. Descri��o dos locais de dor?\r\n7. Teste trigger point');
INSERT INTO encountertemplate VALUES ('s�ncope','0001-01-01 00:00:00','1. Interrogat�rio sobre dor abdominal?\r\n2. Interrogat�rio sobre pelo menos um dos seguintes?\r\nconstipa��o\r\ndiarr�ia\r\nsangramento retal\r\nh�bito intestinal\r\n3. Interrogat�rio sobre intoler�ncia alimentar?\r\n4. Exame abdominal?\r\n5. Toque retal?\r\n6. Sangue oculto nas fezes OU dentro de um ano?\r\n7. Enema opaco registrado no prontu�rio?');
INSERT INTO encountertemplate VALUES ('impot�ncia','0001-01-01 00:00:00','1. Interrogat�rio sobre 3 dos seguintes:\r\nrecorr�ncia ou primeiro epis�dio ou fatores predisponentes');
INSERT INTO encountertemplate VALUES ('ansiedade','0001-01-01 00:00:00','1. Interrogat�rio sobre impot�ncia, constante ou intermitente?\r\n2. Interrogat�rio sobre uso de �lcool\r\n3. Interrogat�rio sobre DM ou doen�a sist�mica?\r\n4. Interrogat�rio sobre problemas emocionais?\r\n5. Interrogat�rio sobre ere��es noturnas\r\n6. Interrogat�rio sobre medica��es?\r\n7. Exame genital?\r\n8. Press�o arterial?\r\n9. Exame abdominal?\r\n10. Exame neurol�gico?\r\n11. Pulsos?\r\n12. An�lise de urina?\r\n13. Glicemia capilar?\r\n14. Um seguimento?\r\n15. SE problema persistir por mais de 3 meses, encaminhamento?\r\n16. Aconselhamento sexual com o parceiro?');
INSERT INTO encountertemplate VALUES ('hematuria','0001-01-01 00:00:00','1. Declara��o dos sintomas?\r\n2. Interrogat�rio sobre dura��o dos sintomas?\r\n3. Interrogat�rio sobre fatores desencadeantes?\r\n4. SE queixas f�sicas, evid�ncia no exame da �rea afetada?\r\n5. SE uso de ansiol�ticos, dosagem e dura��o registrados?\r\n6. SE primeira prescri��o de medica��o, retorno dentro de 2 semanas?\r\n7. Aconselhamento ou encaminhamento?');
INSERT INTO encountertemplate VALUES ('menorragia','0001-01-01 00:00:00','1. Interrogat�rio sobre primeiro epis�dio ou epis�dios recorrentes?\r\n2. Interrogat�rio sobre freq��ncia da hemat�ria?\r\n3. Presen�a/aus�ncia de dor em flanco?\r\n4. presen�a/aus�ncia de dis�ria OU freq��ncia?\r\n5. hemat�ria vis�vel ou microsc�pica?\r\n6. presen�a/aus�ncia de c�lica?\r\n7. exame abdominal?\r\n8. percuss�o dos flancos, achados documentados?\r\n9. SE masculino, exame retal e genital?\r\n10. SE feminino e dois epis�dios ou mais no �ltimo ano, exame p�lvico?\r\n11. An�lise de Urina E bacterioscopia?\r\n12. Urocultura?\r\n13. Ur�ia E/OU Creatinina?\r\n14. SE segundo epis�dio dentro de dois anos, IVP OU encaminhamento?\r\nse > 60 anos e causa n�o identificada, encaminhamento?');
INSERT INTO encountertemplate VALUES ('c�ncer de pr�stata','0001-01-01 00:00:00','1. Interrogat�rio sobre padr�o do sangramento,dura��o e quantidade?\r\n2. SE\r\n3. Exame p�lvico na primeira consulta ou quando sangramento parar?\r\n4. Hb?\r\n5. Exame Papanicolau na primeira consulta ou quando sangramento parar?\r\n6. Causa estabelicida OU encaminhamento dentro de 3 meses da primeira consulta pelo problema?');
INSERT INTO encountertemplate VALUES ('vulvites e vaginites','0001-01-01 00:00:00','1. interrogat�rio sobre sintomas urin�rios?\r\n2. Toque retal pelo menos anualmente?\r\n3. PSA anualmente?\r\n4. SE sintomas novos ou mudan�a dos sintomas, an�lise de urina e urocultura?\r\n5. anatomopatol�gico positivo?\r\n6. Retorno de 6/6 meses?');
INSERT INTO encountertemplate VALUES ('infertilidade feminina','0001-01-01 00:00:00','1. interrogat�rio sobre pelo menos um dos seguintes: prurido vaginal');
INSERT INTO encountertemplate VALUES ('laringite','0001-01-01 00:00:00','1. paridade?\r\n2. infertilidade por mais de 2 anos?\r\n3. interrogat�rio sobre hist�ria medicamentosa?\r\n4. interrogat�rio sobre hist�ria menstrual?\r\n5. exame p�lvico?\r\n6. exame das mamas?\r\n7. Exame c�rdio-pulmonar dentro de dois anos ap�s diagn�stico inicial?\r\n8. Exame Papanicolau E/OU encaminhamento?\r\n9. an�lise do s�mem?');
INSERT INTO encountertemplate VALUES ('dor cervical','0001-01-01 00:00:00','1. interrogat�rio sobre dura��o?\r\n2. interrogat�rio sobre tabagismo?');
INSERT INTO encountertemplate VALUES ('dor cervical ','0001-01-01 00:00:00','1. interrogat�rio sobre dor cervical?\r\n2. interrogat�rio sobre presen�a/aus�ncia de trauma?');
INSERT INTO encountertemplate VALUES ('dor cervical','0001-01-01 00:00:00','3.interrogat�rio sobre um dos seguintes:\r\ndor referida para ombro e parestesia de antebra�o com fraqueza dos membros');
INSERT INTO encountertemplate VALUES ('dor cervical ','0001-01-01 00:00:00','4. cometimento de reflexos nos membros superiores?');
INSERT INTO encountertemplate VALUES ('fraturas','0001-01-01 00:00:00','5. presen�a/aus�ncia de fraqueza de extremidades?\r\n6. Queixa de crepita��o ao movimentar o pesco�o OU sentro de 1 ano?\r\n7. RX coluna cervical registrado no prontu�rio?');
INSERT INTO encountertemplate VALUES ('artrite','0001-01-01 00:00:00','1. descri��o do acidente?\r\n2. tempo desde o cidente?\r\n3. local do traumatismo?');
INSERT INTO encountertemplate VALUES ('dermatite de estase','0001-01-01 00:00:00','');
INSERT INTO encountertemplate VALUES ('piolho e escabiose','0001-01-01 00:00:00','1. queixa sobre o local?\r\n2. interrogat�rio sobre dura��o?\r\n3. presen�a/aus�ncia de veias varicosas?\r\n4. descri��o das les�es?\r\n5. retorno dentro de 1 m�s?');
INSERT INTO encountertemplate VALUES ('blefarite','0001-01-01 00:00:00','1. interrogat�rio sobre prurido?\r\n2. localiza��o?\r\n3. SE escabiose, descri��o das les�es de pele');
INSERT INTO encountertemplate VALUES ('uretrite','0001-01-01 00:00:00','1. interrogat�rio sobre sintomas?\r\n2. dura��o dos sintomas?\r\n3. Uso de ester�ides fluorinados?\r\n4.orienta��o sobre cuidados com o olho?');
INSERT INTO encountertemplate VALUES ('amigdalite aguda','0001-01-01 00:00:00','1. interrogat�rio sobre sintomas urin�rios?\r\n2.interrogat�rio sobre contato sexual ou traumatismo?\r\n3. presen�a/aus�ncia de secre��o uretral?\r\n4. exame genital?\r\n5. An�lise de Urina e bacterioscopia?\r\n6. Urocultura?\r\n7. SE presen�a de secre��o, swab uretral com cultura e antibiograma?\r\n8. VDRL ou FTA abs?\r\n9. SE uso de antibi�tico, foi prescrito penicilina, eritromicina, cefalosporina, sulfonamida ou tetraciclina?\r\n10. retorno dentro de 2 semanas?\r\n11. SE cultura de urina ou do swab uretral positiva ap�s tratamento, mudan�a de antibi�tico?\r\n12. SE cultura de urina ou do swab uretral positiva, discuss�o sobre notifica��o do parceiro sexual?');
INSERT INTO encountertemplate VALUES ('cistite recorrente','0001-01-01 00:00:00','1. interrogat�rio sobre inflama��o da garganta?\r\n2. descri��o das am�gdalas?\r\n3. SE prescrito eritromicina, cefalosporina ou sulfa?\r\n4. se > 4 anos, foi prescrito cefalosporina ou sulfa?\r\n5. SE >= 13 anos, uso de penicilina, eritromicina\r\ncefalosporina, sulfa ou tetraciclina?\r\n6. SE prescrito tetraciclina, era paciente');
INSERT INTO encountertemplate VALUES ('broncopneumonia','0001-01-01 00:00:00','1. queixa de algum sintoma urin�rio?\r\n2. An�lise de urina ou por fita?\r\n3.Urocultura?\r\n4. Ur�ia registrada no prontu�rio?');
INSERT INTO encountertemplate VALUES ('hematoma','0001-01-01 00:00:00','1. um ou mais dos seguintes:\r\ntosse\r\ndispn�ia');
INSERT INTO encountertemplate VALUES ('obstru��o renal','0001-01-01 00:00:00','1. interrogat�rio sobre hist�ria e tipo do trauma\r\n2. espont�neo ou traum�tico?\r\n3. SE espont�neo, interrogat�rio sobre epis�dios anteriores\r\n4. SE espont�neo, interrogat�rio sobre hist�ria familiar de sangramento\r\n5. descri��o do tamanho?\r\n6. descri��o do local?\r\n7. SE espont�neo, hemograma, plaquetas, tempo de protrombina, tempo de tromboplastina feitos?\r\n8. SE atendido nas primeiras 48 horas do acontecimento, gelo recomendado?\r\n9. SE espont�neo OU recorrente, um retorno?\r\n10. SE crian�a');
INSERT INTO encountertemplate VALUES ('nasofaringite ou ?','0001-01-01 00:00:00','1. interrogat�rio sobre a dor?\r\n2. exame abdominal?\r\n3. press�o arterial?\r\n4. Ur�ia e creatinina?\r\n5. An�lise de Urina, cultura e antibiograma?\r\n6. Pielografia intravenosa mostra bloqueio?\r\n7. encaminhamento dentro de 1 semana?');
INSERT INTO encountertemplate VALUES ('migr�nea','0001-01-01 00:00:00','1. queixa de pelo menos um dos seguintes?\r\ndescarga nasal\r\ninflama��o da garganta\r\nastenia\r\nfrio\r\n2. dura��o dos sintomas?\r\n3. SE tosse na hist�ria, exame do t�rax?\r\n4. SE paciente\r\n5. SE inflama��o de garganta na hist�ria, exame de orofaringe?\r\n6. SE prescri��o de antituss�genos, tosse na hist�ria?\r\n7. SE prescri��o de antibi�ticos, hist�ria de infec��o secund�ria?');
INSERT INTO encountertemplate VALUES ('prostatite cr�nica','0001-01-01 00:00:00','1. interrogat�rio sobre presen�a/aus�ncia de aura?\r\n2. SE aura presente, interrogat�rio sobre tipo de aura?\r\n3. interrogat�rio sobre localiza��o da dor?\r\n4. interrogat�rio sobre mudan�as na dor de cabe�a?\r\n5. exame neurol�gico no �ltimo ano\r\n6. press�o arterial no �ltimo ano?\r\n7. SE prescri��o de medica��o, dosagem registrada?\r\n8. SE prescri��o de medica��o, dura��o registrada?');
INSERT INTO encountertemplate VALUES ('infec��o do trato urin�rio','0001-01-01 00:00:00','1. interrogat�rio sobre pelo menos 3 dos seguintes:\r\ndis�ria\r\nfreq��ncia\r\ndor perineal\r\ndispareunia\r\nsecre��o uretral\r\ndor lombar\r\nnict�ria\r\n2. exame abdominal?\r\n3. Toque retal?\r\n4. descri��o da pr�stata');
INSERT INTO encountertemplate VALUES ('insufici�ncia card�aca congestiva','0001-01-01 00:00:00','1. interrogat�rio sobre dura��o dos sintomas?\r\n2. interrogat�rio sobre primeiro epis�dio ou epis�dios recorrentes?\r\n3. interrogat�rio sobre pelo menos 2 dos seguintes:\r\nfreq��ncia\r\ndis�ria\r\nhemat�ria\r\nfebre\r\n4. exame abdominal?\r\n5. Presen�a/ aus�ncia de sensibilidade em flanco OU CVA?\r\n6. SE mais de 2 infec��es dentro de 1 ano em mulher, exame vaginal?\r\n7. An�lise de Urina e bacterioscopia?\r\n8. Urocultura?\r\n9. SE tr�s ou mais ocorr�ncia');
INSERT INTO encountertemplate VALUES ('cefal�ia em salva','0001-01-01 00:00:00','1. interrogat�rio sobre pelo menos 2 dos seguintes:\r\ndispn�ia\r\nedema de membros inferiores\r\ndispn�ia parox�stica noturna\r\nintoler�ncia a exerc�cios\r\n2. Lista de medicamentos atuais?\r\n3. exame do t�rax?\r\n4. medida de peso em pelo menos 50% das consultas?\r\n5. press�o arterial?\r\n6. queixa sobre tornozelos ou press�o venosa jugular?');
INSERT INTO encountertemplate VALUES ('displasia do colo uterino','0001-01-01 00:00:00','1. hist�ria de crises em salvas?\r\n2. crise aguda e de pequena dura��o e recorrente v�rias vezes em 24 horas? \r\n3. descri��o da dor incluindo 2 dos seguintes:\r\nrubor facial ou sudorese\r\nlacrimejamento unilateral\r\ncongest�o nasal\r\n4. press�o arterial?\r\n5. exame neurol�gico, incluindo anota��o sobre pares cranianos?\r\n6. retorno dentro de 6 meses\r\n7. SE medica��o, retorno dentro de 1 m�s');
INSERT INTO encountertemplate VALUES ('cefal�ia','0001-01-01 00:00:00','1. exame de papanicolau pelo menos anualmente?\r\n2. SE �tero presente, seguimento anual?\r\n3. SE prsente em menos de um ano, resgatar o per�odo de seguimento?');
INSERT INTO encountertemplate VALUES ('�lcera vulvar herp�tica','0001-01-01 00:00:00','1. interrogat�rio sobre pelo menos 6 dos seguintes:\r\ngravidade\r\nfreq��ncia\r\nlocaliza��o\r\nfatores desencadeantes\r\nhist�ria medicamentosa\r\ndura��o dos sintomas\r\nsintomas associados');
INSERT INTO encountertemplate VALUES ('amea�a de aborto','0001-01-01 00:00:00','1. interrogat�rio sobre hist�ria de les�o vaginal?\r\n2. descri��o da les�o?\r\n3. localiza��o da les�o?\r\n4. cultura viral?');
INSERT INTO encountertemplate VALUES ('dermatofitose','0001-01-01 00:00:00','1. data da �ltima menstrua��o?\r\n2. volume de sangramento vaginal?\r\n3. dura��o do sangramento vaginal?\r\n4. contra��es uterinas presentes?\r\n5. SE sangramento intenso ou spotting cont�nuo por uma semana, exame p�lvico?\r\n6. teste de gravidez?\r\n7. Hb?\r\n8. Ht?\r\n9. fator Rh?\r\n10. tipagem sangu�nea?\r\n11. teste de gravidez positivo?\r\n12. orienta��o de repouso?\r\n13.uso de progesterona ou estrog�nio?\r\n14. seguimento pelo menos uma vez por semana durante o sangramento?');
INSERT INTO encountertemplate VALUES ('amenorr�ia prim�ria','0001-01-01 00:00:00','1. localiza��o\r\n2. extens�o\r\n3. se griseofulvina prescrita, raspado de pele para cultura e antibiograma?\r\n4. antif�ngicos t�picos usados?\r\n5. SE griseofulvina prescrita, antif�ngicos t�picos foram usados por um m�s primeiramente?\r\n6. retorno dentro de 3 meses?\r\n7. SE griseofulvina prescrita, hemograma dentro de 3 meses?');
INSERT INTO encountertemplate VALUES ('fimose','0001-01-01 00:00:00','1. hist�ria familiar?\r\n2. hist�ria do crescimento?\r\n3. hist�ria do desenvolvimento sexual?');
INSERT INTO encountertemplate VALUES ('lombalgia','0001-01-01 00:00:00','1. interrogat�rio sobre dor?\r\n2. prep�cio n�o redut�vel pelo paciente?\r\n3. descri��o do p�nis?\r\n4. tentativa de redu��o pelo m�dico?\r\n5. aconselhamento sobre cuidados com o p�nis?\r\n6. SE m�dico n�o consegue reduzir, acompanhamento ou encaminhamento?');
INSERT INTO encountertemplate VALUES ('epistaxe','0001-01-01 00:00:00','1. interrogat�rio sobre dura��o e localiza��o da dor?\r\n2. interrogat�rio sobre presen�a ou aus�ncia de um dos seguintes:\r\nparestesia\r\naltera��o sensorial\r\nirradia��o da dor\r\n3. interrogat�rio sobre presen�a/aus�ncia de trauma?\r\n4. interrogat�rio sobre epis�dio anterior');
INSERT INTO encountertemplate VALUES ('caxumba','0001-01-01 00:00:00','1. interrogat�rio sobre freq��ncia?\r\n2. interrogat�rio sobre dura��o?\r\n3. quantidade de sangue perdido estimado?\r\n4. inspe��o do nariz\r\n5. SE sangramento ativo na hora da consulta, press�o arterial aferida?\r\n6. SE > 60 anos, hemoglobina?\r\n7. SE sangramento nasal recorrente');
INSERT INTO encountertemplate VALUES ('hiperlipidemia','0001-01-01 00:00:00','1. interrogat�rio sobre dura��o dos sintomas?\r\n2. tumefa��o na �rea da par�tida?\r\n3. SE masculino > 11 anos, exame dos test�culos?\r\n4. SE uso de analg�sicos, s�o eles AAS ou acetaminofeno?');
INSERT INTO encountertemplate VALUES ('bronquite aguda','0001-01-01 00:00:00','1. hist�ria familiar ou registro no prontu�rio?');
INSERT INTO encountertemplate VALUES ('C�LICA NA INF�NCIA','0001-01-01 00:00:00','1. Queixa de tosse?\r\n2. Queixa de expectora��o?\r\n3. exame do t�rax?\r\n4. temperatura?\r\n5. SE uso de antibi�ticos, dose e dura��o');
INSERT INTO encountertemplate VALUES ('DIABETES MELITUS, J','0001-01-01 00:00:00','1. Interrogat�rio sobre pelo menos dois dos seguintes\r\nv�mito\r\nperistalse\r\neructa��o\r\nflatul�ncia\r\ningesta de l�quido\r\n2. Interrogat�rio sobre tempo de choro\r\n3. Peso registrado com o diagn�stico inicial\r\n4. Queixa sobre a apar�ncia do beb�\r\n5. Evid�ncia de choro logo ap�s alimentar-se\r\n6. Pelo menos um retorno com queixa da situa��o da c�lica?\r\n7. Evid�ncia de algum apoio para os pais');
INSERT INTO encountertemplate VALUES ('PSOR�ASE','0001-01-01 00:00:00','1. Pelo menos a cada 6 meses, queixa de um dos seguintes?\r\npoli�ria\r\npolidipsia\r\nperda de peso\r\n2. Descri��o de fundo (de olho) desde o �ltimo ano ou evid�ncia no prontu�rio');
INSERT INTO encountertemplate VALUES ('ARTRITE DEGENERATIVA','0001-01-01 00:00:00','1. Interrogat�rio sobre a dura��o das les�es ou registro no prontu�rio');
INSERT INTO encountertemplate VALUES ('ACNE VULGAR','0001-01-01 00:00:00','1. Uso de cortic�ide oral');
INSERT INTO encountertemplate VALUES ('GASTROENTERITE','0001-01-01 00:00:00','1. Se uso de antibi�ticos ');
INSERT INTO encountertemplate VALUES ('EPICONDILITE','0001-01-01 00:00:00','1. Interrogat�rio sobre presen�a ou aus�ncia de v�mito\r\n2. Se v�mito, qual a freq��ncia e volume estimado?\r\n3. Interrogat�rio sobre freq��ncia, consist�ncia e presen�a de muco nas fezes\r\n4. Interrogat�rio sobre presen�a ou aus�ncia de sangue nas fezes?\r\n5. Interrogat�rio sobre dura��o dos sintomas?\r\n6. Interrogat�rio sobre hist�ria de viagem?\r\n7. Exame abdominal?\r\n8. Se crian�a\r\n9. Coment�rio sobre presen�a/aus�ncia de desidrata��o\r\n10. Se n�o h� resposta em 2 dias, hemograma?\r\n11. Se n�o h� resposta em 2 dias, coprocultura?\r\n12. Se n�o h� resposta em 2 dias, eletr�litos?\r\n13. Se n�o h� resposta em 2 dias, sangue oculto nas fezes?\r\n14. Se gastroenterite, presen�a de diarr�ia e v�mitos?\r\n15. Uso de anti-espasm�dicos, anti-diarr�icos, ou antibi�ticos?\r\n16. Orienta��o sobre evitar sucos �cidos e leite?');
INSERT INTO encountertemplate VALUES ('TUMORA��O MAM�RIA','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o?\r\n2. Interrogat�rio sobre causas?\r\n3. Registro dos achados na palpa��o?\r\n4. Presen�a de dor localizada?\r\n5. Presen�a de sensibilidade � palpa��o do local afetado?\r\n6. Conselho sobre evitar atividades que causam ou precipitam o problema?');
INSERT INTO encountertemplate VALUES ('ANEMIA FERROPRIVA','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o\r\n2. Interrogat�rio sobre presen�a/aus�ncia de dor?\r\n3. Interrogat�rio sobre mudan�as relativas ao ciclo menstrual?\r\n4. Tamanho da tumora��o?\r\n5. Localiza��o, descri��o espec�fica ou diagrama?\r\n6. Presen�a/aus�ncia de g�nglios axilares?\r\n7. Refer�ncia ou consulta de seguimento dentro de quatro semanas?\r\n8. Se n�o houve encaminhamento previamente e n�o houve mudan�a na tumora��o ou ele � grande, um dos seguintes?\r\nencaminhamento\r\naspira��o\r\nmamografia\r\nexcis�o');
INSERT INTO encountertemplate VALUES ('ESCARLATINA','0001-01-01 00:00:00','**NOTA**\r\nn�o gestante, nova consulta\r\n1. Interrogat�rio sobre sangramento intestinal?\r\n2. Interrogat�rio sobre sangramento de outras origens');
INSERT INTO encountertemplate VALUES ('ATROFIA VAGINAL','0001-01-01 00:00:00','');
INSERT INTO encountertemplate VALUES ('C�LON IRRIT�VEL','0001-01-01 00:00:00','1. Interrogat�rio sobre pelo menos um dos seguintes\r\ndispareunia\r\ndis�ria\r\nsangramento vaginal\r\nprurido vaginal\r\n2. Descri��o de vulva e/ou vagina\r\n3. Papanicolau para �ndice de cariopicnose\r\n4. Se dis�ria, an�lise de urina e bacterioscopia? \r\n5. Cultura e antibiograma de secre��ovaginal?\r\n6. Se uso de agente t�pico, premarim/estr�geno conjugado ou dienesterol creme?\r\n7. Se em uso de terapia oral com estr�geno, retorno dentro de um ano?\r\n8. Se disfun��o sexual ou dispareunia identificada, aconselhamento?');
INSERT INTO encountertemplate VALUES ('ESPONDILITE ANQUILOSANTE','0001-01-01 00:00:00','1. Interrogat�rio sobre funcionamento intestinal ou c�imbras, nos �ltimos 6 meses?\r\n2. Exame abdominal, uma vez por ano?\r\n3. Sangue oculto nas fezes no �ltimo ano?\r\n4. Exame sigmoidosc�pico ou registro no prontu�rio');
INSERT INTO encountertemplate VALUES ('OTITE M�DIA AGUDA','0001-01-01 00:00:00','1. Interrogat�rio sobre presen�a/aus�ncia de dor?\r\n2. Interrogat�rio sobre hist�ria de rigidez?\r\n3. Queixa sobre rigidez anualmente?\r\n4. Queixa sobre varia��o (limita��o) do movimento anualmente?\r\n5. Queixa sobre presen�a/aus�ncia de deformidade?\r\n6. HLA-B27 positivo ou registro de RX positivo ou consulta pr�via confirmat�rio?\r\n7. Uso de cortic�ide oral iniciado no primeiro atendimento?\r\n8. Se uso de alguma medica��o, retorno anualmente?');
INSERT INTO encountertemplate VALUES ('MORDEDURA DE ANIMAL','0001-01-01 00:00:00','1. Descri��o dos sintomas?\r\n2. Dura��o dos sintomas?\r\n3. Otoscopia?\r\n4. Queixa de um dos seguintes\r\nhiperemia do t�mpano\r\nabaulamento do t�mpano\r\ndiminui��o do reflexo de luz\r\n5. Se uso de tetraciclina ou cloranfenicol, era paciente\r\n6. Antibi�ticos prescritos por no m�nimo 10 dias?\r\n7. Se > 4 anos, o antibi�tico usado foi penicilina, eritromicina ou ampicilina?\r\n8. SE, o antibi�tico usado foi penicilina, amoxicilina, sulfa ou eritromicina?\r\n9. Retorno em 04 semanas do epis�dio para estadiamento da condi��o do paciente?');
INSERT INTO encountertemplate VALUES ('HORD�OLO','0001-01-01 00:00:00','1. Interrogat�rio sobre o tipo do animal?\r\n2. Interrogat�rio sobre se o animal foi provocado ou n�o?\r\n3. Descri��o da ferida?\r\n4. Se n�o fez dose de vacina anti-tet�nica h� mais de 10 anos, vacina��o foi feita?\r\n5. SE animal n�o provocado, queixa sobre o risco de raiva? ');
INSERT INTO encountertemplate VALUES ('INFARTO MIOC�RDICO','0001-01-01 00:00:00','1. P�lpebra dolorosa ou inchada? ');
INSERT INTO encountertemplate VALUES ('CARDITE REUM�TICA','0001-01-01 00:00:00','**NOTA**\r\nAS PERGUNTAS DE 1 A 6 DEVEM ESTAR PRESENTES AO MENOS EM 75% DAS VISITAS. \r\n1. Interrogat�rio sobre a rela��o da dor no peito com atividades?\r\n2. Interrogat�rio sobre palpita��es? \r\n3. Interrogat�rio sobre dispn�ia?\r\n4. PA? \r\n5. Ausculta tor�cica? \r\n6. Ausculta cardiaca? ');
INSERT INTO encountertemplate VALUES ('PROSTATITE','0001-01-01 00:00:00','1. Interrogat�rio sobre ao menos um dos seguintes\r\ndispn�ia aos esfor�os\r\nintoler�ncia a esfor�o\r\ndor tor�cica\r\nfadiga\r\n2. Descri��o de sons card�acos, ritmo, murm�rios?\r\n3. PA?\r\n4. SE dispon�vel na comunidade, ecocardiograma? \r\n5. Raio X de t�rax?\r\n6. SE antibioticoprofilaxia, foi penicilina, cefalosporina, sulfonamida, eritromicina? \r\n7. Conselho sobre cobertura com antibi�tico para procedimentos cir�rgicos');
INSERT INTO encountertemplate VALUES ('CERATITE','0001-01-01 00:00:00','1. Interrogat�rio sobre dis�ria? \r\n2. Interrogat�rio sobre dor?\r\n3. Pr�stata sens�vel?\r\n4. Sum�rio de urina?\r\n5. Cultura e antibiograma urina?\r\n6. Antibi�ticos usados e dose?\r\n7. Antibi�ticos usados e dura��o?\r\n8. Aconselhamento sobre abandono de pelo menos um dos seguintes: caf�, �lcool, fumo, condimentos?\r\n9. Retorno dentro de 2 semanas? ');
INSERT INTO encountertemplate VALUES ('ARTRITE MONOARTICULAR','0001-01-01 00:00:00','1. Interrogat�rio sobre ao menos um dos seguintes\r\nfotofobia\r\ndor nos olhos\r\nsecre��o ocular\r\nlacrimejamento\r\n2. Dura��o dos sintomas?\r\n3. Descri��o da c�rnea? \r\n4. Colora��o fluorescente?\r\n5. Uso de col�rio de corticoster�ide?\r\n6. Retorno dentro de 48 horas? \r\n7. Se n�o h� melhora em 48h, encaminhamento?');
INSERT INTO encountertemplate VALUES ('DEGENERA��O DISCAL','0001-01-01 00:00:00','**NOTA**\r\nUma das grandes articula��es: tornozelo, joelho, quadril, punho, cotovelo, ombro. \r\n1. Interrogat�rio sobre dor?\r\n2. Localiza��o?\r\n3. Interrogat�rio sobre dura��o dos sintomas? \r\n4. Interrogat�rio sobre presen�a/aus�ncia de trauma?\r\n5. Descri��o da articula��o? \r\n6. Registro da temperatura OU hist�ria de febre?\r\n7. Presen�a de articula��o bastante dolorosa com anormalidade ao exame?\r\n8. Diagn�stico definitivo em 3 dias OU encaminhamento? ');
INSERT INTO encountertemplate VALUES ('PERFURA��O TIMP�NICA','0001-01-01 00:00:00','1. Interrogat�rio sobre dor lombar, ao menos um dos seguintes\r\ndura��o\r\nlocaliza��o\r\nirradia��o\r\n2. Queixa sobre movimenta��o da coluna, ao menos um dos seguintes? \r\nflex�o\r\nextes�o\r\nflex�o lateral\r\nrota��o\r\n3. RX de coluna lombar');
INSERT INTO encountertemplate VALUES ('ARTRITE REUMAT�IDE','0001-01-01 00:00:00','1. Interrogat�rio sobre a causa?\r\n2. Interrogat�rio sobre a dor?\r\n3. Interrogat�rio sobre descarga de secre��o?\r\n4. Localiza��o da perfura��o?\r\n5. Tamanho da perfura��o? \r\n6. Seguimento at� a resolu��o ou refer�ncia? ');
INSERT INTO encountertemplate VALUES ('OXIUR�ASE','0001-01-01 00:00:00','**NOTA**\r\nEstas quest�es aplicam-se somente para artrite reumat�ide com diagn�stico pr�vio\r\n1. Interrogat�rio sobre dor?\r\n2. Interrogat�rio sobre rigidez? \r\n3. Interrogat�rio sobre fadiga?\r\n4. Coment�rio sobre edema de articula��es durante o ano?\r\n5. Coment�rio sobre limita��o de movimento durante o ano?\r\n6. Retorno ao menos uma vez por ano?\r\n7. Se o paciente faz uso de AINES OU cloroquina OU penicilamina OU metotrexate OU ouro ');
INSERT INTO encountertemplate VALUES ('RUB�OLA','0001-01-01 00:00:00','1. Interrogat�rio sobre prurido anal ou vulvar?\r\n2. Exame para detectar ovos E/OU vermes no �nus? \r\n3. Teste de oxi�rus?\r\n4. Uso de pamoato de pirantel ou pamoato de pirvinium\r\n5. A fam�lia inteira tratou-se simultaneamente?\r\n6. Parasitol�gico de fezes positivo OU teste do oxiurus positivo? ');
INSERT INTO encountertemplate VALUES ('CELULITE','0001-01-01 00:00:00','1. Interrogat�rio sobre ao menos um dos seguintes? \r\ncrescimento de g�nglios enfartados\r\ncongest�o nasal\r\nmialgia, conjuntivite\r\nfebre, dor abdominal\r\notalgia ou dor de garganta\r\n2. Interrogat�rio sobre a dura��o dos sintomas?\r\n3. Exantema not�vel? \r\n4. Presen�a dos n�dulos retro-auriculares palp�veis?');
INSERT INTO encountertemplate VALUES ('LINFADENOPATIA','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o?\r\n2. Localiza��o da les�o?\r\n3. Extens�o/tamanho da les�o?\r\n4. Temperatura? \r\n ***NOTA***\r\nAs quest�es de 5 a 8 aplicam-se se a les�o tem mais de 5 polegadas de di�metro ou se este � o terceito epis�dio (ou mais)\r\n5. Leucograma registrado no prontu�rio?\r\n6. Sum�rio de urina registrado no prontu�rio?\r\n7. Cultura e antibiograma da les�o?\r\n8. Registro de glicemia no �ltimo ano?\r\n9. Uso de antibi�ticos por pelo menos 7 dias? \r\n10. Se uso de antibi�tico, qual o tipo?\r\n11. Se uso de antibi�tico, qual a dose?\r\n12. Retorno em 7 dias? ');
INSERT INTO encountertemplate VALUES ('BURSITE','0001-01-01 00:00:00','1. Interrogat�rio sobre a localiza��o dos g�nglios?\r\n2. Interrogat�rio sobre a dura��o? \r\n3. Descri��o do n�dulo');
INSERT INTO encountertemplate VALUES ('GRAVIDEZ E PARTO','0001-01-01 00:00:00','1. Interrogat�rio sobre dor OU edema?\r\n2. Interrogat�rio sobre a localiza��o?\r\n3. Interrogat�rio sobre dura��o?\r\n4. Descri��o do local da les�o');
INSERT INTO encountertemplate VALUES ('SANGRAMENTO RETAL','0001-01-01 00:00:00','1. Registros de Pr�-Natal?\r\n2. Sum�rio de Urina em cada consulta? \r\n3. Hemoglobina a cada trimestre?\r\n4. Se glicos�ria positiva repetida em 2 testes, glicemia, TTGO ou encaminhamento?\r\n5. Se an�lise de urina por fita positiva, relat�rio do laborat�rio da an�lise de urina e microscopia? \r\n6. Se hemoglobina \r\n7. Se uso de drogas');
INSERT INTO encountertemplate VALUES ('URTICARIA','0001-01-01 00:00:00','1. Interrogat�rio sobre ao menos 2 dos seguintes: \r\nvolume\r\ntipo de sangramento\r\ndura��o do sangramento\r\n2. Interrogat�rio sobre h�bitos intestinais?\r\n3. Exame abdominal? \r\n4. Exame retal?\r\n5. Hemoglobina dentro de 1 semana? \r\n6. Proctoscopia dentro de 1 semana?\r\n7. Sigmoidoscopia ou encaminhamento dentro de 2 semanas?\r\n8. SE > 30, o enema baritado E contraste a�reo dentro de 1 m�s?\r\n9. SE 30 anos ou menos E nenhuma causa foi encontrada na sigmoidoscopia, enema baritado E contraste a�reo dentro de 1 m�s?\r\n10. Enema baritado E/OU sigmoidoscopia dentro de 1 m�s?\r\n11. SE nenhum diagn�stico foi estabelecido ap�s 1 m�s, encaminhar/consulta OU indicar a justificativa?\r\n12. Se n�o for hemorr�ida, retorno? ');
INSERT INTO encountertemplate VALUES ('FOLICULITE ','0001-01-01 00:00:00','1. Interrogat�rio sobre a dura��o do rash?\r\n2. Interrogat�rio sobre a localiza��o do rash?\r\n3. Interrogat�rio sobre poss�vel causa.');
INSERT INTO encountertemplate VALUES ('CORPO ESTRANHO EM CAVIDADE NASAL','0001-01-01 00:00:00','1. Questionar se � o primeiro epis�dio ou se � recorrente\r\n2. Descri��o da erup��o?\r\n3. Localiza��o?\r\n4. Se recorrente');
INSERT INTO encountertemplate VALUES ('ABSCESSO CUT�NEO','0001-01-01 00:00:00','1. Interrogat�rio sobre como o corpo estranho entrou no nariz\r\n2. Interrogat�rio sobre qual o lado afetado? \r\n3. SE removido, descri��o do corpo estranho? \r\n4. SE n�o removido, refenciar ao otorrinolaringologista dentro de 24 horas?');
INSERT INTO encountertemplate VALUES ('ESTOMATITE, MONIL�ASE','0001-01-01 00:00:00','1. Interrogat�rio sobre a posi��o?\r\n2. Interrogat�rio sobre se � o primeiro epis�dio ou se � recorrente? \r\n3. Descri��o do tamanho?\r\n4. Presen�a/aus�ncia de flutua��o?\r\n5. Presen�a/aus�ncia de linfangite?\r\n6. Cultura e antibiograma do pus?\r\n7. SE recorrente, glicemia capilar?\r\n8. Demonstra��o do pus?\r\n9. Dose infectante?\r\n10. Retorno dentro de 10 dias? ');
INSERT INTO encountertemplate VALUES ('BRONQUITE CR�NICA','0001-01-01 00:00:00','1. Interrogat�rio sobre localiza��o e dura��o das les�es orais? \r\n2.� SE adulto, inqu�rito sobre causa subjacente ');
INSERT INTO encountertemplate VALUES ('HIPERTENS�O EM MENORES DE 75 ANOS','0001-01-01 00:00:00','1. Interrogat�rio sobre ocupa��o');
INSERT INTO encountertemplate VALUES ('HIPERTROFIA PROST�TICA BENIGNA','0001-01-01 00:00:00','1. Interrogat�rio sobre hist�ria familiar de AVC e/ou IAM, ou registro no prontu�rio?');
INSERT INTO encountertemplate VALUES ('PIELONEFRITE CR�NICA','0001-01-01 00:00:00','1. Interrogat�rio sobre sintomas urin�rios, ao menos um dos seguintes\r\nnict�ria\r\nfrequencia\r\nfluxo\r\nurg�ncia\r\n2. Descri��o da pr�stata?\r\n3. Sum�rio de Urina?\r\n4. Cultura e antibiograma?\r\n5. Se bexiga distendida, drenar lentamente?\r\n6. Se cateterizado ou obstru�do, encaminhar?');
INSERT INTO encountertemplate VALUES ('IRITE','0001-01-01 00:00:00','1. Interrogat�rio sobre 3 dos seguintes ou registro no prontu�rio');
INSERT INTO encountertemplate VALUES ('REFLUXO ESOF�GICO','0001-01-01 00:00:00','1. Interrogat�rio sobre ao menos um dos seguintes: vis�o borrada, olho doloroso, olho vermelho, fotofobia\r\n2. Descri��o dos olhos\r\n3. Encaminhar ou consulta pelo telefone?');
INSERT INTO encountertemplate VALUES ('ESTOMATITE HERP�TICA','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o dos sintomas?\r\n2. Ao menos dois dos seguintes est� presente?\r\npirose quando reclinado\r\nasia\r\nintoler�ncia a condimentos \r\nintoler�ncia a �lcool\r\ndisfagia\r\nEructa��o\r\n3. Exame abdominal? \r\n4. Se h� disfagia, endoscopia?\r\n5. Se realizada Esofagogastroduodenografia, demonstrado refluxo?\r\n6. Aconselhar sobre eleva��o da cabeceira da cama?\r\n7. Aconselhar sobre dieta');
INSERT INTO encountertemplate VALUES ('ASMA','0001-01-01 00:00:00','1. Interrogat�rio sobre dor em cavidade oral\r\n2. H� ulcera��es?');
INSERT INTO encountertemplate VALUES ('INFLAMA��O P�LVICA','0001-01-01 00:00:00','1. Interrogat�rio sobre ocorr�ncia do quadro previamente\r\n2. Interrogat�rio sobre hist�ria familiar ou registro no prontu�rio');
INSERT INTO encountertemplate VALUES ('HERPES ZOSTER','0001-01-01 00:00:00','1. Interrogat�rio sobre dor p�lvica e secre��o vaginal? \r\n2. Interrogat�rio sobre antecedente de DIP OU de doen�a ven�rea? \r\n3. Interrogat�rio sobre o hist�ria menstrual? \r\n4 Exame p�lvico com queixa de secre��o cervical? \r\n5. Queixa ao exame de anexos?\r\n6. Queixa de sensibilidade (dor) p�lvica');
INSERT INTO encountertemplate VALUES ('N�DULO TIRE�IDEO','0001-01-01 00:00:00','1. Descri��o da les�o\r\n2. Localiza��o da les�o\r\n3. Se les�es em face OU m�dico percebe "distribui��o oft�lmica", exame de c�rnea OU encaminhamento?');
INSERT INTO encountertemplate VALUES ('ABSCESSO PERIAMIDALIANO','0001-01-01 00:00:00','1. Interrogat�rio sobre localiza��o?\r\n2. Interrogat�rio sobre dura��o?\r\n3. Interrogat�rio sobre um dos seguintes?\r\npalpita��es\r\ntremor\r\nperda de peso\r\n4. Descri��o do tamanho da les�o\r\n5. Queixa na localiza��o');
INSERT INTO encountertemplate VALUES ('CONVULS�O FEBRIL','0001-01-01 00:00:00','1. Interrogat�rio sobre dor na garganta?\r\n2.Interrogat�rio sobre dificuldade de engolir ?\r\n3. Exame da garganta?\r\n4. Descri��o da massa?\r\n5. Encaminhamento ou hospitaliza��o?');
INSERT INTO encountertemplate VALUES ('ENURESE NOTURNA','0001-01-01 00:00:00','1. Descri��o da convuls�o\r\n2. Tempo total de dura��o da convuls�o\r\n3. Interrogat�rio sobre hist�ria pr�via de convuls�es?\r\n4. Interrogat�rio sobre febre nas 24h precedentes?\r\n5. Interrogat�rio sobre adoecimento das 24h precedentes?\r\n6. Temperatura?\r\n7. Presen�a/aus�ncia de rigidez de nuca?\r\n8. Exame de ouvido, nariz e garaganta (ONT)?\r\n9. Exame tor�cico?\r\n10 Febre em 24 hora?\r\n11. Se temperatura maior que 38graus ');
INSERT INTO encountertemplate VALUES ('CEFAL�IA TENSIONAL','0001-01-01 00:00:00','**NOTA**\r\nSomente para menores de 4 anos\r\n1. Interrogat�rio sobre hist�ria familiar de enurese? \r\n2. Interrogat�rio sobre freq��ncia de "cama molhada"?\r\n3. Interrogat�rio sobre remiss�es e exacerba��es?\r\n4. Exame genital descrito alguma vez no prontu�rio');
INSERT INTO encountertemplate VALUES ('PLANEJAMENTO FAMILIAR','0001-01-01 00:00:00','1. Interrogat�rio sobre ao menos um dos 5 seguintes?\r\nlocaliza��o\r\ndura��o\r\ntempo de in�cio\r\nfreq��ncia\r\nsintomas associados');
INSERT INTO encountertemplate VALUES ('CLAUDICA��O INTERMITENTE','0001-01-01 00:00:00','1. Interrogat�rio sobre 3 dos seguintes?\r\ngravidezes\r\nabortos\r\nhist�ria menstrual?\r\ncirurgia ginecol�gica\r\nhist�ria de DIP\r\nhist�ria de tabagismo');
INSERT INTO encountertemplate VALUES ('CISTITE','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o da dor?\r\n2. Interrogat�rio sobre uso de tabaco atualmente (quantificar)?\r\n3. Presen�a/aus�ncia de pulsos em membros inferiores?\r\n4. PA? \r\n5. Queixa abdominal ou aneurisma?\r\n6. Queixa dos membros inferiores, temperatura, crescimento de p�los e colora��o (de MMII)\r\n7. Exame c�rdio-pulmonar em 12 meses antes ou 5 meses ap�s apresenta��o?\r\n8. Colesterol ou triglic�rides?\r\n9. Glicemia?\r\n10. Dor em MMII com exerc�cios, ou ao andar, que aliviam com o descanso?\r\n11. Se fuma, aconselhamento sobre parada?\r\n12. Discuss�o sobre o cuidado com os p�s?');
INSERT INTO encountertemplate VALUES ('HIPOTIREOIDISMO','0001-01-01 00:00:00','1. Interrogat�rio sobre um ou mais dos seguintes\r\nurg�ncia\r\nfreq��ncia\r\ndis�ria\r\nhemat�ria\r\n2. Interrogat�rio sobre dura��o dos sintomas?\r\n3. Fitas de urina para an�lise de Protein�ria E hemat�ria OU sum�rio de urina OU urocultura? \r\n4. Urocultura positiva ou dois dos seguintes:\r\nurg�ncia\r\nfreq��ncia\r\ndis�ria\r\nhemat�ria\r\n5. ATB usado: sulfa, ampicilina, sulfa/trimetropim (bactrim), tetraciclina?\r\n6. Um retorno E repetir sum�rio de urina OU\r\nurocultura?\r\n7. Urocultura negativa no prontu�rio no fim do tratamento?\r\n8. Uso de estreptomicina ou cloromicetina?');
INSERT INTO encountertemplate VALUES ('DOR ABDOMINAL','0001-01-01 00:00:00','1. Interrogat�rio sobre tratamento pr�vio para tire�ide?\r\n2. Interrogat�rio sobre pelo menos um dos seguintes\r\nintoler�ncia ao frio\r\n retardo mental, fluxo menstrual \r\nfraqueza generalizada, constipa��o\r\n3. Exame da tire�ide\r\n4. Exame dos reflexos\r\n5. Queixa de ao menos um dos seguintes: \r\npele seca, mudan�a da voz\r\nmixedema, letargia\r\n6. T4?\r\n7. Repetir T4 a cada segunda mudan�a da dose\r\n8. T4 baixo, T3 baixo, ou baixa capta��o, ou TSH alto?\r\n9. Se recente diagn�stico? ');
INSERT INTO encountertemplate VALUES ('NASOFARINGITE','0001-01-01 00:00:00','1. Interrogat�rio sobre tipo da dor?\r\n2. Interrogat�rio sobre dura��o da dor?\r\n3. Interrogat�rio localiza��o da dor?\r\n4. Interrogat�rio sobre presen�a/aus�ncia de intoler�ncia a algum alimento espec�fico?\r\n5. Interrogat�rio sobre presen�a/aus�ncia de sintomas gastro-intestinais?\r\n6. Interrogat�rio sobre presen�a/aus�ncia de febre?\r\n7. Se mulher, interrogat�rio sobre hist�ria menstrual?\r\n8. Exame tor�cico?\r\n9. Exame abdominal?\r\n10. Interrogat�rio sobre presen�a/aus�ncia de ponto doloroso?\r\n11. Se mulher, com dor p�lvica, dor em quadrante inferior esquerdo ou direito: exame p�lvico?\r\n12. Se homem E dor pelvica ou dor em quadrante inferior esquerdo ou direito: exame retal? \r\n13. Sum�rio de Urina e urocultura?\r\n14. Se urina anormal, urocultura e antibiograma?\r\n15. Se segundo epis�dio NOS, cultura e antibiograma?');
INSERT INTO encountertemplate VALUES ('EPILEPSIA','0001-01-01 00:00:00','1. Hist�ria de um dos seguintes?\r\nspray nasal\r\ncongest�o nasal\r\ngotejamento nasal posterior\r\nuso de cigarro\r\nexposi��o a poeira ou fuma�a \r\n2. Descri��o da mucosa nasal\r\n3. Aconselhamento sobre irritantes da mucosa nasal');
INSERT INTO encountertemplate VALUES ('ABORTO, TERAP�UTICA','0001-01-01 00:00:00','1. Tipo e descri��o das crises\r\n2. Freq��ncia das crises\r\n3. Tempo dura��o das crises ');
INSERT INTO encountertemplate VALUES ('MENOPAUSA','0001-01-01 00:00:00','1. Hist�ria obst�trica\r\n2. Data da �ltima menstrua��o?\r\n3. Gravidez percebida?\r\n4. Exame p�lvico, achados ao exame ou encaminhamento?\r\n5. Estimativa de tamanho do �tero, ou n�mero de semanas da gesta��o ou encaminhamento?\r\n6. Fator Rh?\r\n7. Teste de gravidez realizado?\r\n8. Teste de gravidez positivo?\r\n9. Se for indicado fator Rh, RHOGAM/Rh imunoglobulina?\r\n10. Admiss�o para dilata��o e curetagem ou encaminhamento?\r\n11. Planejamento familiar OU conselho sobre acompanhamento at� o nascimento?\r\n12. Retorno em 06 semanas ap�s o aborto?');
INSERT INTO encountertemplate VALUES ('HIPERTIREOIDISMO, TRE?????','0001-01-01 00:00:00','1. Interrogat�rio sobre hist�ria menstrual');
INSERT INTO encountertemplate VALUES ('ANEMIA, NYD','0001-01-01 00:00:00','1. Interrogat�rio sobre um dos seguintes em cada consulta:\r\nenergia\r\npeso\r\nsensibilidade ao calor \r\n2. Se nova consulta nos �ltimos 2 anos, questionar sobre dura��o da doen�a\r\n3. Se nova consulta nos �ltimos 2 anos, examinar tire�ide e olhos?\r\n4. Ritmo card�aco e pulsos em cada consulta?\r\n5. T3 RIA OU TSH anulamente?\r\n6. Ao menos um teste de tire�ide anormal no prontu�rio');
INSERT INTO encountertemplate VALUES ('PIELONEFRITE AGUDA','0001-01-01 00:00:00','**NOTA**\r\nN�O GESTANTE\r\n1. Interrogat�rio sobre perda sangu�nea?\r\n2. Interrogat�rio sobre a dieta?\r\n3. Exame c�rdio-pulmonar dentro de 6 meses?\r\n4. Na consulta, pelo menos 03 dos seguintes\r\nPA\r\npulso\r\nexame abdominal\r\nexame retal\r\n5. Hemoglobina ou hemat�crito?\r\n6. Se n�o h� hist�ria de perda de sangue como causa, esfrega�o de sangue para �ndice?\r\n7. Se paciente negro, pesquisa de deformidades celulares\r\n8. Hemoglobina para homens maiores de 19 anos e para mulheres maiores de 17 anos\r\n9. Se macrocitose ou esfrega�o');
INSERT INTO encountertemplate VALUES ('PTIR�ASE R�SEA','0001-01-01 00:00:00','1. Interrogat�rio sobre pelo menos um dos seguintes:\r\nfreq��ncia urin�ria\r\nurg�ncia miccional\r\ndis�ria');
INSERT INTO encountertemplate VALUES ('HERPANGINA ','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o de rash?\r\n2. Interrogat�rio sobre presen�a de placa?\r\n3. Descri��o da distribui��o?\r\n4. VDRL?\r\n5. Uso de ester�ide oral\r\n6. Aconselhamento sobre dura��o');
INSERT INTO encountertemplate VALUES ('GASTRITE - HIPERACIDEZ','0001-01-01 00:00:00','1 Interrogat�rio sobre dor na garganta?\r\n2. Exame da garganta?\r\n3. Antibi�ticos usados?');
INSERT INTO encountertemplate VALUES ('CONSTIPA��O RECORRENTE','0001-01-01 00:00:00','1. Interrogat�rio sobre localiza��o da dor abdominal\r\n1. Interrogat�rio sobre dura��o da dor abdominal\r\n3. Interrogat�rio sobre tipo de dor abdominal\r\n4. Interrogat�rio sobre fatores agravantes');
INSERT INTO encountertemplate VALUES ('OBESIDADE','0001-01-01 00:00:00','**NOTA**\r\nPacientes com mais de 30 anos com hist�ria pr�via de constipa��o\r\n1. Interrogat�rio sobre mudan�a no funcionamento intestinal\r\n2. Interrogat�rio sobre dieta\r\n3. Interrogat�rio sobre drogas\r\n4. Exame abdominal\r\n5. Exame retal\r\n6. Sangue oculto nas fezes?\r\n7. Se menos de 3 meses de dura��o: enema baritado\r\n8. Movimento intestinal infrequente e/ou dif�cil\r\n9. Instru��es sobre o aumento da ingesta de fibras, farelo e subst�ncias que ajudam na digest�o \r\n10. Retorno ou diagn�stico especificado em 03 meses ');
INSERT INTO encountertemplate VALUES ('ENTORSE OU DISTENS�O, NY','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o da obesidade\r\n2. Peso\r\n3. Altura\r\n4. �ndice de Massa Corp�rea (IMC)?\r\n5. Uso de anorexiantes ou drogas tire�ideas');
INSERT INTO encountertemplate VALUES ('CONCUSS�O CEREBRAL','0001-01-01 00:00:00','1. Interrogat�rio sobre como ocorreu a les�o\r\n2. Interrogat�rio sobre localiza��o da les�o\r\n3. Quando occoreu a les�o\r\n4. Presen�a/aus�ncia de edema\r\n5. Presen�a/aus�ncia de dor\r\n6. Presen�a/aus�ncia de hematoma\r\n7. Se relacionado a esportes, recomenda��es sobre preven��o de futuros epis�dios');
INSERT INTO encountertemplate VALUES ('VARICELA','0001-01-01 00:00:00','1. Descri��o do tipo de trauma\r\n2. Coment�rio sobre a gravidade do trauma\r\n3. Tempo decorrido desde a les�o\r\n4. Presen�a/aus�ncia de altera��o de consci�ncia desde a les�o\r\n5. Hist�ria de diminui��o de consci�ncia\r\n6. Exame neurol�gico\r\n7. Exame do local da les�o\r\n8. RX de cr�nio\r\n9. Se paciente n�o internado, enfaixamento de rotina da les�o em cabe�a, OU instru��es?\r\n10. Uso de narc�ticos ou sedativos?\r\n11. Intera��o no hospital ou encaminhamento?');
INSERT INTO encountertemplate VALUES ('PLEURITE','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o dos sintomas?\r\n2. Descri��o do rash\r\n3. Presen�a de bolha, p�pula ou ves�cula\r\n4. Uso de AAS?');
INSERT INTO encountertemplate VALUES ('PNEUMONIA LOBAR','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o dos sintomas?\r\n2. Interrogat�rio sobre localiza��o da dor\r\n3. Presen�a/aus�ncia de febre\r\n4. Presen�a/aus�ncia de tosse\r\n5. Interrogat�rio sobre intensifica��o da dor � respira��o profunda');
INSERT INTO encountertemplate VALUES ('LACERA��ES DE PELE','0001-01-01 00:00:00','1. Interrogat�rio sobre os seguintes:\r\ntosse\r\ndispn�ia\r\ndor no peito\r\nfebre\r\n2. Descri��o da ausculta pulmonar\r\n3. Macicez � percuss�o ou condensa��es\r\n4. Cultura e antibiograma de escarro?\r\n5. Leucograma?\r\n6. RX de t�rax em duas posi��es?\r\n7. Se RX confirmat�rio, retorno em 30 dias\r\n8. Cultura positiva e RX positivo ou consolida��o ao exame\r\n9. Penicilina oral, ou eritromicina ou cefalosporina?\r\n10. Dose?\r\n11. Quantidade (dias)?\r\n12. Retorno em 01 semana');
INSERT INTO encountertemplate VALUES ('OTITE M�DIA SEROSA','0001-01-01 00:00:00','** NOTA**\r\nPara as quest�es de 1-7 o m�dico dever� cumprir as condi��es para cada epis�dio de lacera��o\r\n1. Interrogat�rio sobre como ocorreu a lacera��o\r\n2. Tempo decorrido da les�o at� o atendimento\r\n3. Descri��o da les�o\r\n4. Se m�o ou pulso, queixa sobre a fun��o\r\n5. Se tend�es foram atingidos: encaminhamento?\r\n6. Desbridamento');
INSERT INTO encountertemplate VALUES ('DIABETES MELITUS, A ???','0001-01-01 00:00:00','1. Interrogat�rio sobre dois dos seguintes: audi��o, dor, infec��es recorrentes?\r\n2. Queixa de secre��o em ouvido m�dio ou retra��o de membrana?\r\n3. Queixa sobre nariz e garganta\r\n4. Se � o terceiro epis�dio ou mais, audiometria ou encaminhamento?\r\n5. Se o exame f�sico ou o teste de ouvido est�o anormais, acompanhamento at� a cura ou encaminhamento?');
INSERT INTO encountertemplate VALUES ('C�NCER DE PR�STATA','0001-01-01 00:00:00','1. Interrogat�rio sobre hist�ria de diabetes familiar');
INSERT INTO encountertemplate VALUES ('PUERICULTURA','0001-01-01 00:00:00','1. Interrogat�rio sobre sintomas urin�rios?\r\n2. Exame retal ao menos anualmente?\r\n3. PSA anualmente?\r\n4. Se sintomas urin�rios novos ou alterados, cultura e antibiograma e sum�rio de urina?\r\n5. Laudo patol�gico positivo?\r\n6. Retorno a cada 6 meses?');
INSERT INTO encountertemplate VALUES ('ARTRITE, NYD OU N�O','0001-01-01 00:00:00','1. Interrogat�rio sobre a alimenta��o/dieta\r\n2. Interrogat�rio aos pais sobre habilidades? \r\n3. Peso em cada consulta\r\n4. Coment�rios sobre marcos normais/anormais no desenvolvimento? \r\n5. Medida de comprimento tr�s vezes ou mais por ano?\r\n6. Registro do per�metro cef�lico ao menos 3 vezes no primeiro ano de vida? \r\n7. Tr�s doses de DPT at� os 8 meses ou justificativa para mudan�a no curso\r\n8. Se 1-2 anos, MMR entre 12-15 meses; DPT entre 17-19 meses ou justificativa para altera��o no curso?\r\n9. Se maior de 1 ano, ao menos 3 visitas no primeiro ano?\r\n10. Se maior de 2 anos, ao menos 3 visitas no segundo ano?\r\n11. Se os pais identificaram problemas: aconselhamento ou encaminhamento?\r\n12. Administrado MMR antes dos 12 anos?');
INSERT INTO encountertemplate VALUES ('HEMATOMA SUBCUT�NEO','0001-01-01 00:00:00','**NOTA**\r\nmenos de um m�s - m�ltiplas articula��es\r\n1. Interrogat�rio sobre dura��o dos sintomas?\r\n2. Localiza��o da dor articular?\r\n3. Descri��o da natureza ou gravidade da dor?\r\n4. Interrogat�rio sobre fatores agravantes ou precipitantes?\r\n5. Descri��o da inflama��o ou edema?\r\n6. Descri��o da varia��o de movimento?\r\n7. Antes da ou na segunda consulta para o mesmo problema, hemograma?\r\n8. Antes da ou na segunda visita para o mesmo problema, taxa de sedimenta��o de hem�cias?\r\n9. Antes da ou na segunda visita para o mesmo problema, FAN?');
INSERT INTO encountertemplate VALUES ('DERMATITE DE CONTATO','0001-01-01 00:00:00','1. Interrogat�rio sobre hist�ria de trauma e tipo?\r\n2. Interrogat�rio sobre: espont�neo ou trauma?\r\n3. Se espont�neo, questionar epis�dios pr�vios?\r\n4. Se espont�neo, hist�ria familiar de sangramentos?\r\n5. Descri��o do tamanho?\r\n6. Descri��o da localiza��o?\r\n7. Se espont�neo, feitos TTP, TP, hemograma, PLAQUETAS?\r\n8. Se foi atendido dentro de 48h, foi recomendado gelo?\r\n9. Se espont�neo ou recorrente, um retorno?\r\n10. Se crian�a');
INSERT INTO encountertemplate VALUES ('AMENORR�IA SECUND�RIA','0001-01-01 00:00:00','**NOTA**\r\nIncluindo veneno de planta\r\n1. Interrogat�rio sobre dura��o?\r\n2. Interrogat�rio sobre prurido\r\n3. Interrogat�rio sobre exposi��o a irritantes?\r\n4. Localiza��o do rash?\r\n5. Se uso de prednisona oral, n�o mais que sete dias?\r\n6. Se uso de prednisona oral, retorno ou contato pelo telefone?');
INSERT INTO encountertemplate VALUES ('DIARR�IA DE REPETI��O','0001-01-01 00:00:00','1. Hist�ria menstrual?\r\n2. Dura��o do problema?\r\n3. Descri��o do in�cio do problema?\r\n4. Hist�ria de medica��es?');
INSERT INTO encountertemplate VALUES ('P�LIPO NASAL','0001-01-01 00:00:00','1. Interrogat�rio sobre a freq��ncia?\r\n2. Interrogat�rio sobre a dura��o?\r\n3. Interrogat�rio sobre a dieta?\r\n4. Interrogat�rio sobre uso de medica��es?\r\n5. Interrogat�rio sobre viagens?\r\n6. Interrogat�rio sobre sangue nas fezes?\r\n7. Interrogat�rio sobre febre?\r\n8. Interrogat�rio sobre perda de peso?\r\n9. Interrogat�rio sobre n�usea, dor abdominal tipo c�lica?\r\n10. Exame abdominal?\r\n11. Exame retal?\r\n12. Peso ao menos uma vez?\r\n13. Fezes para cultura e antibiograma?\r\n14. Fezes com ovos ou parasitas?\r\n15. Hemograma?\r\n16. Taxa de sedimenta��o de hem�cias?\r\n17. Sigmoidoscopia, ou colonoscopia, ou encaminhamento?\r\n18. Enema baritado?\r\n19. Se enema baritado negativo, Esofagogastroduodenografia com estudo de intestino delgado\r\n20. Se n�o houve melhora em seis meses, ou n�o houve diagn�stico espec�fico, encaminhamento?');
INSERT INTO encountertemplate VALUES ('ESCOLIOSE','0001-01-01 00:00:00','1. Interrogat�rio sobre sintomas nasais?\r\n2. Interrogat�rio sobre hist�ria de asma ou alergia AAS?');
INSERT INTO encountertemplate VALUES ('LES�O EM CAVIDADE ORAL','0001-01-01 00:00:00','**NOTA**\r\nApenas com o paciente presente\r\n1. Interrogat�rio sobre como foi percebida a condi��o?\r\n2. Descri��o da localiza��o?');
INSERT INTO encountertemplate VALUES ('GLAUCOMA','0001-01-01 00:00:00','1. Interrogat�rio sobre a localiza��o?\r\n2. Interrogat�rio sobre a dura��o?\r\n3. Descri��o da les�o?\r\n4. Se les�o descrita for �lcera, ou placa e n�o cicatrizada em dois meses, investiga��o ou encaminhamento? ');
INSERT INTO encountertemplate VALUES ('AMIDALITE CR�NICA','0001-01-01 00:00:00','1. Interrogat�rio sobre a vis�o em cada visita\r\n**NOTA**\r\nSe o paciente faz seguimento com oftalmologista, as quest�es de 2-8 N�O SE APLICAM\r\n2. Interrogat�rio sobre o correto uso dos medicamentos?\r\n3. Fundoscopia anual para estadiamento de c�pula �ptica?\r\n4. Exame de campos visuais anualmente?\r\n5. Press�o intra-ocular anualmente?\r\n6. Medica��es e dosagens administradas?\r\n7. Aumento da press�o intra-ocular?');
INSERT INTO encountertemplate VALUES ('DERMATITE DE CONTATO, ECZEMA','0001-01-01 00:00:00','1. Interrogat�rio sobre recorr�ncia de dor de garganta?\r\n2. Descri��o das am�dalas?\r\n3. Presen�a/aus�ncia de g�nglios cervicais palp�veis?\r\n4. Se antibi�tico: penicilina, eritromicina, cefalosporina, tetraciclina?\r\n5. Se amidalectomia ou encaminhamento, houve mais de 4 epis�dios em 02 anos ou abscesso periamidaliano?');
INSERT INTO encountertemplate VALUES ('DOEN�A FIBROC�STICA','0001-01-01 00:00:00','1. Interrogat�rio sobre dura��o?\r\n2. Presen�a/aus�ncia de hist�ria familiar de eczema ou registro no prontu�rio?');
INSERT INTO encountertemplate VALUES ('FARINGITE','0001-01-01 00:00:00','1. Interrogat�rio sobre ao menos dois dos seguintes:\r\ndor na mama\r\ncomportamento peri�dico da protuber�ncia \r\nrecorr�ncia do problema\r\nlocaliza��o da protuber�ncia\r\n2. Descri��o de ambas mamas?\r\n3. Indica��o da posi��o e do tamanho das protuber�ncias?\r\n4. Exame axilar?\r\n5. Se diagnosticado como n�o c�stico, mamografia?\r\n6. Se suspeita de cisto, aspira��o ou refer�ncia?\r\n7. Exame das mamas pelo m�dico anualmente ap�s o diagn�stico inicial?\r\n8. Cisto diagnosticado pelo exame ou mamografia?\r\n9. Ultrassom mam�rio a cada dois anos?\r\n10. Se persiste uma discreta protuber�ncia ap�s a aspira��o, encaminhamento?');
INSERT INTO encountertemplate VALUES ('SINUSITE','0001-01-01 00:00:00','1. Interrogat�rio sobre dor na garganta?\r\n2. Interrogat�rio sobre dura��o?\r\n3. Exame da faringe?\r\n4. Se membrana esbranqui�ada ou exsudato vis�vel,sorologia para mononucleose e cultura e antibiograma?\r\n5. Hiperemia?');
INSERT INTO encountertemplate VALUES ('GOTA','0001-01-01 00:00:00','1. Interrogat�rio sobre dor na face ou cefal�ia?\r\n2. Interrogat�rio sobre congest�o nasal?\r\n3. Presen�a/aus�ncia de febre?\r\n4. Presen�a/aus�ncia de pontos dolorosos sobre os seios?\r\n5. Se recorrente?');
INSERT INTO encountertemplate VALUES ('LES�O NASAL','0001-01-01 00:00:00','1. Interrogat�rio sobre os seguintes:\r\nv�rias articula��es dolorosas?\r\nhist�ria de edema\r\nhist�ria de inflama��o\r\nacometimento de UMA S� articula��o?\r\n2. Lista das drogas em uso ou registrado no prontu�rio?');
--
-- Dumping data for table 'favorites'
--


--
-- Dumping data for table 'form'
--


--
-- Dumping data for table 'formAR'
--


--
-- Dumping data for table 'formAlpha'
--


--
-- Dumping data for table 'formAnnual'
--


--
-- Dumping data for table 'formLabReq'
--


--
-- Dumping data for table 'formMMSE'
--


--
-- Dumping data for table 'formMentalHealth'
--


--
-- Dumping data for table 'formPalliativeCare'
--


--
-- Dumping data for table 'formPeriMenopausal'
--


--
-- Dumping data for table 'formRourke'
--


--
-- Dumping data for table 'formType2Diabetes'
--


--
-- Dumping data for table 'groupMembers_tbl'
--

INSERT INTO groupMembers_tbl VALUES (0,'88888');
INSERT INTO groupMembers_tbl VALUES (0,'999999');
INSERT INTO groupMembers_tbl VALUES (0,'999998');
INSERT INTO groupMembers_tbl VALUES (0,'999997');
INSERT INTO groupMembers_tbl VALUES (0,'174');
INSERT INTO groupMembers_tbl VALUES (17,'174');
INSERT INTO groupMembers_tbl VALUES (17,'999998');
INSERT INTO groupMembers_tbl VALUES (19,'999997');
INSERT INTO groupMembers_tbl VALUES (18,'999999');
INSERT INTO groupMembers_tbl VALUES (18,'88888');

--
-- Dumping data for table 'groups_tbl'
--

INSERT INTO groups_tbl VALUES (17,0,'doc');
INSERT INTO groups_tbl VALUES (18,0,'receptionist');
INSERT INTO groups_tbl VALUES (19,0,'admin');

--
-- Dumping data for table 'ichppccode'
--

--
-- Dumping data for table 'immunizations'
--

--
-- Dumping data for table 'messagelisttbl'
--



--
-- Dumping data for table 'messagetbl'
--


--
-- Dumping data for table 'mygroup'
--

INSERT INTO mygroup VALUES ('Docs','174','Chan','David','a1');
INSERT INTO mygroup VALUES ('IT Support','88888','Support','IT',NULL);

--
-- Dumping data for table 'oscarcommlocations'
--

INSERT INTO oscarcommlocations VALUES (145,'Oscar Users',NULL,1,'<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<addressBook><group><group desc=\"doc\" id=\"17\"><address desc=\"Chan, David\" id=\"174\"/><address desc=\"oscardoc, doctor\" id=\"999998\"/></group><group desc=\"receptionist\" id=\"18\"><address desc=\"oscarrep, receptionist\" id=\"999999\"/><address desc=\"Support, IT\" id=\"88888\"/></group><group desc=\"admin\" id=\"19\"><address desc=\"oscaradmin, admin\" id=\"999997\"/></group><address desc=\"Chan, David\" id=\"174\"/><address desc=\"oscaradmin, admin\" id=\"999997\"/><address desc=\"oscardoc, doctor\" id=\"999998\"/><address desc=\"oscarrep, receptionist\" id=\"999999\"/><address desc=\"Support, IT\" id=\"88888\"/></group></addressBook>',NULL);

--
-- Dumping data for table 'preference'
--

INSERT INTO preference VALUES (138,'999998','8','18','15','.default','deepblue');

--
-- Dumping data for table 'prescribe'
--


--
-- Dumping data for table 'professionalSpecialists'
--


--
-- Dumping data for table 'property'
--


--
-- Dumping data for table 'provider'
--

INSERT INTO provider VALUES ('999997','oscaradmin','admin','admin','','','','0001-01-01','','','','','','','','1','','');
INSERT INTO provider VALUES ('999998','oscardoc','doctor','doctor','','','','0001-01-01','','','','','','','','1','','');
INSERT INTO provider VALUES ('999999','oscarrep','receptionist','receptionist','','','','0001-01-01','','','','','','','','1','','');
INSERT INTO provider VALUES ('88888','Support','IT','receptionist','','Admin','','0001-01-01','','','','','','','','1','','');
INSERT INTO provider VALUES ('174','Chan','David','doctor','Family Medicine','TEAM A','M','0001-01-01','','H 905-','058081','','','BAAP','1','1','','');

--
-- Dumping data for table 'providerExt'
--


--
-- Dumping data for table 'radetail'
--


--
-- Dumping data for table 'raheader'
--


--
-- Dumping data for table 'recycle_bin'
--


--
-- Dumping data for table 'recyclebin'
--


--
-- Dumping data for table 'remoteAttachments'
--


--
-- Dumping data for table 'reportagesex'
--


--
-- Dumping data for table 'reportprovider'
--

INSERT INTO reportprovider VALUES ('174','Docs','billingreport','A');

--
-- Dumping data for table 'reporttemp'
--


--
-- Dumping data for table 'rschedule'
--


--
-- Dumping data for table 'scheduledate'
--


--
-- Dumping data for table 'scheduledaytemplate'
--


--
-- Dumping data for table 'scheduleholiday'
--

INSERT INTO scheduleholiday VALUES ('2003-12-25','Natal');
INSERT INTO scheduleholiday VALUES ('2004-01-01','Ano novo');

--
-- Dumping data for table 'scheduletemplate'
--


--
-- Dumping data for table 'scheduletemplatecode'
--

INSERT INTO scheduletemplatecode VALUES ('1','Consulta de 15 minutos','15','#BFEFFF');
INSERT INTO scheduletemplatecode VALUES ('2','Consulta de 30 minutos','30','#BFEFFF');
INSERT INTO scheduletemplatecode VALUES ('3','Consulta de 45 minutos','45','#BFEFFF');

--
-- Dumping data for table 'security'
--

INSERT INTO security VALUES (127,'oscarrep','-51-282443-97-5-9410489-60-1021-45-127-12435464-32','999999','1117');
INSERT INTO security VALUES (128,'oscardoc','-51-282443-97-5-9410489-60-1021-45-127-12435464-32','999998','1117');
INSERT INTO security VALUES (129,'oscaradmin','-51-282443-97-5-9410489-60-1021-45-127-12435464-32','999997','1117');

--
-- Dumping data for table 'serviceSpecialists'
--

INSERT INTO serviceSpecialists VALUES (53,297);

--
-- Dumping data for table 'specialistsJavascript'
--

INSERT INTO specialistsJavascript VALUES ('1','function makeSpecialistslist(dec){\n if(dec==\'1\') \n{K(-1,\"----Choose a Service-------\");D(-1,\"--------Choose a Specialist-----\");}\nelse\n{K(-1,\"----All Services-------\");D(-1,\"--------All Specialists-----\");}\nK(53,\"Cardiology\");\nD(53,\"297\",\"ss4444\",\"ssss, sss ssss\",\"sss\",\"sssss\");\n\nK(54,\"Dermatology\");\n\nK(55,\"Neurology\");\n\nK(56,\"Radiology\");\n\nK(57,\"SEE NOTES\");\n\n\n}\n');

--
-- Dumping data for table 'study'
--


--
-- Dumping data for table 'studydata'
--


--
-- Dumping data for table 'tickler'
--


--
-- Dumping data for table 'tmpdiagnosticcode'
--


