# Network Analysis — Portfolio d'investigation réseau

Ce portfolio est consacré à l'analyse de captures réseau PCAP et PCAPNG. Son objectif est de comprendre des scénarios d'attaque, de reconstituer les échanges entre les machines et de documenter les conclusions à partir de preuves observables dans le trafic.

Le projet suit une démarche d'investigation : partir d'une hypothèse, examiner les paquets, expliquer les observations et préciser les limites de ce que la capture permet de conclure.

**État du projet :** 26 captures organisées dans 6 thèmes, avec une fiche d'analyse par capture. Les investigations sont à réaliser ; aucun résultat technique n'est encore publié.

## Sommaire

1. [Présentation du projet](#1-présentation-du-projet)
2. [Environnement et outils](#2-environnement-et-outils)
3. [Organisation du dépôt](#3-organisation-du-dépôt)
4. [Catalogue des investigations](#4-catalogue-des-investigations)
5. [Méthodologie d'analyse](#5-méthodologie-danalyse)
6. [Commencer une investigation](#6-commencer-une-investigation)
7. [Documentation et preuves](#7-documentation-et-preuves)
8. [Avancement et résultats](#8-avancement-et-résultats)
9. [Compétences travaillées](#9-compétences-travaillées)
10. [Sources et références](#10-sources-et-références)

## 1. Présentation du projet

### Contexte

Les captures proviennent de la collection publique [PCAP-ATTACK de sbousseaden](https://github.com/sbousseaden/PCAP-ATTACK). Le travail de ce portfolio porte sur leur investigation et la rédaction des analyses. La collection contient notamment des scénarios dont les noms font référence à Windows, Active Directory, aux communications de commande et contrôle et aux déplacements latéraux.

### Objectifs

- Identifier les machines, les protocoles et les flux utiles à chaque investigation.
- Comprendre la séquence d'actions visible dans la capture.
- Examiner les comportements suspects et les relier à des preuves précises.
- Relever les indicateurs pertinents en expliquant leur contexte.
- Proposer des correspondances MITRE ATT&CK lorsque les observations les justifient.
- Produire des comptes rendus lisibles, vérifiables et utiles pour l'analyse défensive.

### Périmètre

Les investigations portent sur des captures existantes. Les noms des fichiers et leur classement servent de point de départ ; les conclusions doivent être établies à partir du contenu des paquets. L'analyse reste limitée à ce qui est visible dans chaque capture, en tenant compte du chiffrement, des échanges absents et du contexte disponible.

## 2. Environnement et outils

Le dépôt est préparé dans un environnement Windows avec PowerShell. Les outils ci-dessous composent le cadre de travail prévu ; leur utilisation effective et leur version seront précisées dans les analyses concernées.

| Outil ou référence | Rôle dans le projet |
|---|---|
| Wireshark | Examiner les paquets, filtrer les échanges et suivre les flux |
| TShark | Lire et extraire des informations réseau en ligne de commande |
| Capinfos | Consulter les propriétés et les statistiques générales d'une capture |
| Zeek, en complément dans un environnement compatible | Produire des journaux réseau pour compléter certaines investigations |
| PowerShell | Parcourir les fichiers et vérifier leurs empreintes SHA-256 |
| Git et Markdown | Versionner le portfolio et rédiger les comptes rendus |
| MITRE ATT&CK | Mettre les comportements établis en relation avec des tactiques et techniques |

## 3. Organisation du dépôt

Les thèmes sont directement à la racine. Chaque scénario possède un dossier contenant son fichier PCAP original et sa fiche `analyse.md`.

```text
.
├── README.md
├── Command and Control/
├── Credential Access/
├── Defense Evasion/
├── Discovery/
├── Lateral Movement/
└── Privilege Escalation/
```

Exemple d'une investigation :

```text
Discovery/
├── README.md
└── Impacket-RPCDump/
    ├── Discovery_impacket_rpcdump.pcapng
    └── analyse.md
```

Chaque README de thème donne accès aux fiches d'analyse. Les captures d'écran et les exports utiles peuvent ensuite être ajoutés dans le dossier du scénario concerné.

## 4. Catalogue des investigations

Les scénarios ci-dessous sont annoncés par les noms des fichiers et le classement de la collection source. Ils restent à confirmer au cours des investigations.

| Thème | Captures | Scénarios à étudier |
|---|---:|---|
| [Command and Control](./Command%20and%20Control/README.md) | 3 | Foudre et DGA, commandes via DNS TXT, tunnel RDP avec Meterpreter |
| [Credential Access](./Credential%20Access/README.md) | 7 | Password spraying Kerbrute, SpoolSample, MasterKey et BackupMasterKey, DCShadow, DCSync, réinitialisation de mot de passe après Zerologon |
| [Defense Evasion](./Defense%20Evasion/README.md) | 1 | Interruption du service de journalisation des événements |
| [Discovery](./Discovery/README.md) | 5 | Énumération des partages, des utilisateurs, des groupes privilégiés et des services RPC |
| [Lateral Movement](./Lateral%20Movement/README.md) | 9 | PsExec, SMBExec, WMI, DCOM, SharpRDP, Skeleton Key, Zerologon et une capture SIGRed dont le classement reste à vérifier |
| [Privilege Escalation](./Privilege%20Escalation/README.md) | 1 | SMBGhost / CVE-2020-0796, avec trafic loopback annoncé |
| **Total** | **26** | |

Les thèmes conservent le classement historique de la source et ne constituent pas des correspondances MITRE ATT&CK validées. Le fichier SIGRed / CVE-2020-1350 est notamment rangé dans Lateral Movement alors que son nom mentionne un scénario DoS ; son classement sera réévalué lors de l'analyse.

## 5. Méthodologie d'analyse

Chaque investigation suit les mêmes étapes pour faciliter la lecture et la comparaison des résultats.

| Étape | Travail à effectuer | Éléments à consigner |
|---|---|---|
| 1. Cadrer | Définir la question et les hypothèses à vérifier | Contexte disponible et objectif de l'investigation |
| 2. Identifier la capture | Vérifier le fichier et examiner ses propriétés | SHA-256, durée, nombre de paquets, horodatages et fuseau |
| 3. Cartographier | Repérer les hôtes, les protocoles et les conversations | IP, ports, rôles supposés et flux pertinents |
| 4. Investiguer | Filtrer les échanges et examiner les requêtes et réponses | Filtres utilisés, numéros de paquets et observations |
| 5. Reconstituer | Remettre les événements dans l'ordre | Chronologie reliée aux preuves |
| 6. Conclure | Évaluer les hypothèses et les correspondances possibles | Résultats, limites, indicateurs contextualisés et pistes de détection |

Une hypothèse peut être confirmée, écartée ou rester indéterminée. Chaque conclusion doit indiquer les éléments qui la soutiennent et ce qui reste incertain.

## 6. Commencer une investigation

1. Choisir un thème dans le catalogue, puis ouvrir la fiche `analyse.md` d'un scénario.
2. Ouvrir le fichier PCAP associé dans Wireshark.
3. Renseigner le contexte, les propriétés de la capture et les premières hypothèses.
4. Appliquer les filtres utiles et documenter les observations avec leurs références de paquets.
5. Compléter la chronologie, la conclusion et les limites de l'analyse.

Par exemple, la fiche [Impacket-RPCDump](./Discovery/Impacket-RPCDump/analyse.md) se trouve à côté de sa capture dans le thème Discovery.

Pour vérifier l'intégrité de ce fichier depuis PowerShell, à la racine du dépôt :

```powershell
$capturePath = '.\Discovery\Impacket-RPCDump\Discovery_impacket_rpcdump.pcapng'
Get-FileHash -LiteralPath $capturePath -Algorithm SHA256
```

Comparer l'empreinte obtenue à celle indiquée dans la fiche d'analyse. Si Capinfos est installé et accessible dans le `PATH`, consulter les propriétés de la capture avec :

```powershell
capinfos $capturePath
```

Ces commandes préparent l'investigation. Les observations et les conclusions sont à rédiger dans la fiche associée.

## 7. Documentation et preuves

Chaque fiche `analyse.md` comprend :

- L'objectif, le contexte et l'identification du fichier source.
- Une vue d'ensemble de la capture et des machines impliquées.
- Les filtres Wireshark utilisés et leur objectif.
- Les observations reliées aux paquets, aux flux et aux captures d'écran.
- La chronologie des événements.
- Les indicateurs observés et les correspondances MITRE ATT&CK justifiées.
- La conclusion, les limites et les références consultées.

Pour rendre l'analyse vérifiable, les preuves doivent préciser les numéros de paquets ou de flux ainsi que les horodatages et le fuseau utilisé. Une adresse IP ou un domaine est à présenter avec son rôle dans le scénario ; sa présence dans une capture ne suffit pas à en faire un indicateur malveillant.

Les fichiers PCAP conservent leur nom et leur contenu d'origine. Leur intégrité a été vérifiée par SHA-256 lors de l'organisation du projet.

## 8. Avancement et résultats

| Élément | État actuel |
|---|---|
| Captures classées à la racine | 26 / 26 |
| Fiches d'analyse préparées | 26 / 26 |
| Investigations documentées | 0 / 26 |
| Conclusions et correspondances ATT&CK validées | À établir au fil des analyses |

Une investigation sera considérée comme documentée lorsque sa fiche contiendra un objectif, des observations appuyées par des preuves et une conclusion exposant les limites de l'analyse. Les résumés des résultats seront ajoutés ici avec un lien vers les fiches terminées.

### Prochaines étapes

- [ ] Documenter une première investigation complète.
- [ ] Ajouter les captures d'écran et les références de paquets utiles.
- [ ] Confirmer les techniques observées et revoir les classements incertains.
- [ ] Mettre à jour les index des thèmes et le suivi d'avancement.
- [ ] Comparer les scénarios étudiés pour dégager des pistes de détection.

## 9. Compétences travaillées

Ce portfolio vise à développer les compétences suivantes. Les analyses terminées permettront d'en montrer l'application concrète.

| Compétence | Application attendue dans les investigations |
|---|---|
| Analyse réseau | Identifier les protocoles, les conversations et les relations entre hôtes |
| Investigation défensive | Formuler des hypothèses et les évaluer à partir des échanges observés |
| Lecture du trafic Windows et Active Directory | Examiner les scénarios annoncés autour de SMB, RPC, Kerberos et des services associés |
| Analyse chronologique | Reconstituer une séquence d'actions avec des horodatages vérifiables |
| Utilisation de MITRE ATT&CK | Justifier une correspondance par les comportements établis |
| Rédaction technique | Expliquer les résultats, les preuves et les limites dans un compte rendu structuré |

## 10. Sources et références

### Origine des captures

Les captures sont issues de [sbousseaden/PCAP-ATTACK](https://github.com/sbousseaden/PCAP-ATTACK). Le crédit de leur création revient à leurs auteurs respectifs. Ce dépôt les organise pour construire un portfolio d'analyses documentées.

Une archive locale de provenance, exclue du suivi Git dans `.sources/`, conserve les métadonnées et l'historique du dépôt importé, le README précédent ainsi que l'inventaire des déplacements et les empreintes SHA-256. La navigation publique du portfolio repose sur les dossiers de thèmes et leurs fiches d'analyse.

### Documentation de référence

- [Guide utilisateur Wireshark](https://www.wireshark.org/docs/wsug_html_chunked/).
- [Manuel TShark](https://www.wireshark.org/docs/man-pages/tshark.html).
- [Manuel Capinfos](https://www.wireshark.org/docs/man-pages/capinfos.html).
- [Guide de démarrage Zeek](https://docs.zeek.org/en/current/quickstart.html).
- [MITRE ATT&CK — Enterprise](https://attack.mitre.org/tactics/enterprise/).

Les références propres à un scénario seront ajoutées à sa fiche lors de l'investigation.
