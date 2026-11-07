# Network Analysis

Projet personnel d'analyse de trafic reseau a partir de captures PCAP et PCAPNG

Je construis ce portfolio pour travailler sur des cas pratiques de securite reseau principalement autour de Windows et Active Directory. Le but est de comprendre les echanges entre les machines et de retrouver les actions visibles dans les paquets

Le depot contient 26 captures reparties dans 6 themes. Les analyses restent a completer

## Objectifs

- Comprendre le fonctionnement des protocoles presents dans les captures
- Identifier les flux suspects et les actions associees
- Reconstituer le deroulement d'un scenario avec les numeros de paquets
- Documenter les observations et les limites de chaque analyse
- Relier les comportements observes aux techniques MITRE ATT&CK

## Outils

Outils prevus pour les investigations

- Wireshark pour les filtres et l'analyse des paquets
- TShark et Capinfos pour travailler sur les captures en ligne de commande
- PowerShell pour la gestion des fichiers et la verification SHA-256
- Zeek en complement pour l'exploitation des logs reseau

## Captures

| Theme | PCAP | Scenarios a etudier |
|---|---:|---|
| [Discovery](./Discovery/README.md) | 5 | RPCDump, NetShareEnum, PsLoggedOn, enumeration des groupes et des services RPC |
| [Credential Access](./Credential%20Access/README.md) | 7 | Kerbrute, SpoolSample, DCSync, DCShadow et acces aux cles de sauvegarde |
| [Lateral Movement](./Lateral%20Movement/README.md) | 9 | PsExec, SMBExec, WMI, DCOM, SharpRDP, Skeleton Key, Zerologon et SIGRed |
| [Command and Control](./Command%20and%20Control/README.md) | 3 | Foudre DGA, commandes DNS TXT et tunnel RDP avec Meterpreter |
| [Defense Evasion](./Defense%20Evasion/README.md) | 1 | Crash du service de journalisation des evenements |
| [Privilege Escalation](./Privilege%20Escalation/README.md) | 1 | SMBGhost CVE-2020-0796 |

Les noms des scenarios viennent des fichiers sources. Le classement sera ajuste selon les observations faites pendant les analyses. SIGRed est par exemple range dans Lateral Movement dans la collection source alors que le fichier indique un scenario DoS

## Organisation

Un dossier par theme et un sous-dossier par capture avec le PCAP original et son fichier `analyse.md`

```text
Discovery/
├── README.md
└── Impacket-RPCDump/
    ├── Discovery_impacket_rpcdump.pcapng
    └── analyse.md
```

Les captures d'ecran et les exports utiles seront ajoutes dans le dossier de l'analyse concernee

## Methode d'analyse

Je commencerai par les informations generales de la capture puis les IP, les ports et les protocoles. Ensuite je suivrai les conversations utiles pour comprendre les requetes, les reponses et l'ordre des actions

Chaque compte rendu regroupe

- Le contexte et l'objectif de l'analyse
- Les machines et les protocoles identifies
- Les filtres Wireshark utilises
- Les observations avec les numeros de paquets et les horodatages
- La chronologie et les correspondances MITRE ATT&CK si elles sont justifiees
- La conclusion et les limites de ce qui est visible dans la capture

Les noms et le contenu des PCAP sont conserves. L'empreinte SHA-256 de chaque fichier est disponible dans sa fiche d'analyse

## Avancement

Les dossiers et les fiches d'analyse sont prets. Aucune investigation n'est encore terminee

Les comptes rendus seront ajoutes au fur et a mesure avec les captures d'ecran et les preuves associees

## Sources

Les captures viennent du depot [PCAP-ATTACK de sbousseaden](https://github.com/sbousseaden/PCAP-ATTACK). Mon travail porte sur leur analyse et la redaction des comptes rendus

- [Documentation Wireshark](https://www.wireshark.org/docs/wsug_html_chunked/)
- [Documentation TShark](https://www.wireshark.org/docs/man-pages/tshark.html)
- [Documentation Capinfos](https://www.wireshark.org/docs/man-pages/capinfos.html)
- [Documentation Zeek](https://docs.zeek.org/en/current/quickstart.html)
- [MITRE ATT&CK](https://attack.mitre.org/tactics/enterprise/)
