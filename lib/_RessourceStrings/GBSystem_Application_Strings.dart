import 'package:flutter/material.dart';

class GbsSystemStrings {
  // logo && name
  static const str_app_name = "CodeCharge";

//
  //Colors
  static const str_primary_color = Color(0xff1564c0);

  ///Change Password
  static const str_password_changed = "mot de passe changé avec succès";
  static const str_mail_sended = "mail envoyé avec succès";
  static const String str_scan_page = "Page de Scannaire";
  static const String str_chose_carte = "Choisie la Carte";
  static const String str_scan_succes = 'Scan Successful!';
  static const String str_scanning = 'Scanning...';
  static const String str_not_started_yet = 'Not Started Yet';

  ///
  /// Boarding Page
  static const str_boarding_passer = "Passer";
  static const str_boarding_commencer = "Commencer";

  static const str_boarding1_title = "my title 1 boarding 1";
  static const str_boarding1_subtitle = "my subtitle 1 boarding 1";

  static const str_boarding2_title = "my title 2 boarding 2";
  static const str_boarding2_subtitle = "my subtitle 2 boarding 2";

  static const str_boarding3_title = "my title 3 boarding 3";
  static const str_boarding3_subtitle = "my subtitle 3 boarding 3";

  static const str_boarding4_title = "my title 4 boarding 4";
  static const str_boarding4_subtitle = "my subtitle 4 boarding 4";
//////

//Dialog
  static const str_dialog_avertissement = "avertissement";
  static const str_dialog_erreur = "Erreur";
  static const str_dialog_succes = "Succes";
  static const str_dialog_info = "Info";

  static const str_annuler = "Annuler";
  static const str_ok = "ok";
  static const str_connexion = "Connexion";

  static const str_disponibiliter_propositions_de_vacation =
      "Dispo/propo de vacation";
  static const str_exclusions_propositions_vacation = "Excl/propo de vacation";

  ///

//Error Pages
  static const str_error_no_connection_title =
      "Opps, pas de connexion Internet";

  static const str_waiting_for_tag = "Waiting for NFC Tag";
  static const str_nfc = "NFC";

  static const str_error_connection_returned_title = "Connexion rétablie !";

  static const str_error_server_title = "Opps, quelque chose s'est mal passé";
  static const str_refresh = "Rafraîchir";
  static const str_quitter = "Quitter";
  static const str_modifier = "Medifier";
  static const str_creer = "Créer";
  static const str_appyier = "Taper";
  static const str_fois_pour_quiter = "fois pour quitter";
  static const str_fois_pour_activer_mode =
      "fois pour activer mode enregistrer serveur";

////

// Login page

  static const str_mode_enregistrer_server_active =
      "mode enregistrer serveur bien activer";
  static const str_mode_enregistrer_server = "enregistrer serveur";
  static const str_mode_identification = "identification";
  static const str_validator_site_web =
      r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$';
  static const String str_validat_svp_enter_site = "Svp entrer le site";
  static const String str_validat_svp_enter_mail = "Svp entrer l'email";

  static const String str_validat_svp_enter_site_valide =
      "Svp entrer un site valide";
  static const String str_validat_svp_enter_password =
      "svp entrer le mot de passe";
  static const String str_validat_password_length =
      "mot de passe contian au moins 8 caractéres";
  static const String str_validat_password_must_be_the_same =
      "le mot de passe doit être le même";

  static const String str_site_s19_changed =
      "le site et S19 sont changé avec succes";

  static const String str_site_changed = "le site est changé avec succes";
  static const String str_email_required = "Email is required";
  static const String str_password_required = "Password is required";
  static const String str_password_contain_6_car =
      "Password must contain at least 6 caracters";

  static const String str_enter_valid_email = "Enter a valid email";
  static const String str_changement_mot_passe = "Changement de mot de Passe";

  static const String str_droits_reserved =
      "© BM Soft 2022 Tous droits réserés";
  static const String str_droits_reserved_part_1 = "© BM Soft";
  static const String str_droits_reserved_part_2 = "Tous droits réserés";

  static const str_validator_mail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const String str_site = "Site";
  static const String str_mail = "Email";
  static const String str_s19 = "S19";
  static const String str_password = "Password";
  static const String str_mot_de_passe_oublier = "Mot de passe oublié ?";
  static const String str_change_password = "Changer le mot de passe";

////Change password screen
  static const String str_old_password = "Old Password";
  static const String str_reset_password = "Reset Password";

  static const String str_new_password = "new Password";
  static const String str_new_password_confirmation =
      "Confirmation new Password";

  ///
//// Home Page
  ///
  static const String str_bienvenue = "Bienvenue";
  static const String str_prise_de_vacation = "Prise de vacation";
  static const String str_tenue = "Tenue";
  static const String str_notes_de_frais = "Notes de frais";

  static const String str_messagerie = "Messagerie";
  static const String str_options = "Options";
  static const String str_changment_mot_de_passe = "Changement de mot de passe";

  static const String str_deconnexion_question =
      "Voulez-vous vous déconnecter ?";
  static const String str_acceder_a_vos_informations =
      "Accéder à vos informations";
  static const String str_fermer = "fermer";
  static const String str_aucune_vacation = "aucune vacation sur server";
  static const String str_entrer = "Entrée";
  static const String str_entreprise = "Entreprise";

  static const String str_sortie = "Sortie";

  static const String str_deconnecter = "Se déconnecter";
  static const String str_pointage_entrer_succes =
      "Pointage entrée avec succées";
  static const String str_pointage_sortie_succes =
      "Pointage sortie avec succées";
  static const String str_mal_tourner = "quelque chose s'est mal passé";
  static const String str_location_denied =
      "vous devez accepter l'autorisation de localisation";
  static const String str_aucune_vacation_trouver = "Aucune vacation de trouvé";
  static const String str_adresse = "adresse";

  static const String str_publier_le = "Publiée le";
  static const String str_publier = "Publiée";

  static const String str_distance = "Distance";

  static const String str_latitude = "latitude";
  static const String str_longitude = "longitude";
  static const String str_ville = "ville";

  static const String str_lieu = "lieu";
  static const String str_telephone = "Téléphone";
  static const String str_portable = "Portable";
  static const String str_code_sms = "Code SMS";
  static const String str_code_email = "Code Email";
  static const String str_field_required = "Champ obligatoire";

  static const String str_qualification = "Qualification";
  static const String str_duree = "Durée";
  static const String str_pause = "Pause";
  static const String str_date_demande = "date demande";
  static const String str_description = "Description";
  static const String str_propositions = "Propositions";
  static const String str_cloturer = "Cloturé";

  static const String str_habilitations = "Habilitations";
  static const String str_agrements = "Agréments";
  static const String str_agrement = "Agrément";

  static const String str_diplomes = "Diplômes";
  static const String str_diplome = "Diplôme";

  static const String str_documents_officiels = "Documents officiels";
  static const String str_documents_officiel = "Documents officiel";

  static const String str_date_obtention = "Date d'obtention";
  static const String str_date_validiter = "Validité du";
  static const String str_date_pro = "Date Pro";

  static const String str_fin_validiter = "Fin de validité";
  static const String str_numero_document = "N° Doc";
  static const String str_motif = "Motif";

  static const String str_date_debut = "date début";
  static const String str_hour_debut = "heure début";
  static const String str_date_fin = "date fin";
  static const String str_hour_fin = "heure fin";
  static const String str_etat = "état";
  static const String str_debut = "début";
  static const String str_fin = "fin";
  static const String str_saisire = "saisire";

  static const String str_exclu_ponctuelle = "Exclusion ponctuelle";
  static const String str_exclu_recurrente = "Exclusion récurrente";
  static const String str_dispo_recurrente = "Disponibilité récurrente";

  static const String str_exclu_definitive = "Exclusion définitive";
  static const String str_dispo_definitive = "Disponibilité définitive";

  static const String str_dispo_ponctuelle = "Disponibilité ponctuelle";
  static const String str_absence = "Absence";
  static const String str_info_salarie = "Info salarie";
  static const String str_documents = "documents";
  static const String str_document = "document";

  static const String str_select_date = "Sélectionner une date";
  static const String str_calculer = "Calculer";
  static const String str_choisie_un_fichier = "Choisir un fichier";
  static const String str_aucune_fichier_choisie = "Aucune fichier choisi";
  static const String str_piece_jointe = "piéces jointes";
  static const String str_att_vos_devez_valider_docs =
      "Attention : Vous devez valider vos documents";
  static const String str_carte_proffisionel = "Carte professionnelle";

  static const String str_demande_absence = "Demande d'absence";
  static const String str_demande_vacation = "Demande vacation";
  static const String str_map = "Map";
  static const String str_code_pin = "Code PIN";
  static const String str_verification = "Vérification";
  static const String str_enregistrement = "Enregistrement";

  static const String str_entrer_code_pin_deja_enrigester =
      "Entrer le code PIN qui est déja enregistré pour continuer";
  static const String str_enrigester_nv_code_pin =
      "Enregistrer un nouveau code PIN pour continuer";

  static const String str_accepter_proposition = "Accepter proposition";
  static const String str_proposition = "proposition";
  static const String str_proposition_s = "Proposition(s)";

  static const String str_list_preferences = "Liste des préferences";
  static const String str_placement_cet = "Placement CET";
  static const String str_rachat_cet = "Rachat CET";
  static const String str_prise_de_jours_cet = "Prise de jours CET";

  static const String str_valider_vos_documents = "valider vos documents";

  static const String str_demande = "Demande";
  static const String str_demander = "Demandé";
  static const String kDemander = "Demander";

  static const String str_demande_indisponibiliter =
      "Demande d'indisponibilité";
  static const String str_indisponibiliter = "indisponibilités";
  static const String str_indisponibiliter_recurrentes =
      "Indisponibilités récurrentes";

  static const String str_indisponibiliter_ponctuelle =
      "Indisponibilités ponctuelle";

  static const String str_disponibiliter = "Disponibilité";
  static const String str_cet = "CET";
  static const String solde_des_jours_de_cet = "Solde des jours de CET";

  static const String str_solde_des_absences = "Solde des absences";
  static const String str_list_des_indisponibiliter =
      "Liste des indisponibilités";

  static const String str_plages_horaires = "Plages Horaires";
  static const String str_aucune_vacation_prec =
      "il y ai aucune vacation précident";
  static const String str_aucune_vacation_suiv =
      "il y ai aucune vacation suivant";
  static const String str_pointage_en_cours = "pointage en cours ...";
  static const String str_operation_en_cours = "opération en cours ...";

  ///
  /// Select item screen
  static const String str_app_bar_select_item = "selectionner un item";
  static const String str_my_info = "mes informations";
  static const String str_info = "Info";

  static const String str_historique = "historique";
  static const String svp_ecrire_un_message = "écrire un messsage svp";
  static const String svp_select_type = "séléctionner un type svp";

  static const String str_demande_absence_du = "Demande d'absence du";
  static const String str_au = "au";
  static const String str_effectuee_le = "effectuée le";
  static const String str_clotures_le = "Cloturée le";
  static const String str_refuser_le = "Refusée le";
  static const String str_acceptation_le = "Acceptée le";
  static const String str_proposer_le = "Proposée le";

  static const String str_nom = "Nom";
  static const String str_nombre_des_jours = "Nombre de Jours";
  static const String str_nombre_des_telechargement =
      "Nombre de téléchargement";

  static const String str_prenom = "Prénom";

  static const String str_selectDate = "selectDate";
  static const String str_cancel = "cancel";
  static const String str_done = "done";
  static const String str_prevMonth = "prevMonth";
  static const String str_nextMonth = "nextMonth";
  static const String str_prevYear = "prevYear";
  static const String str_nextYear = "nextYear";
  static const String str_datePickerInputHint = "Enter date";
  static const String str_datePickerHelpText = "Select Date";

  static const String str_Select_Time = "Select Time";
  static const String str_hour = "hour";
  static const String str_minute = "minute";
  static const String str_timePickerInputHint = "Enter time";
  static const String str_timePickerHelpText = "Select Time";

  static const String str_monday = "monday";
  static const String str_tuesday = "tuesday";

  static const String str_rechercher = "rechercher";
  static const String str_qte = "Quantité";
  static const String str_taille = "Taille";

  static const String str_rendre = "à rendre";
  static const String str_pas_rendre = "n'est pas à rendre";
  static const String str_loading_map = "chargement de la map";

  static const String str_empty_data = "il y a aucune élément";

  static const String str_empty_pdf = "le pdf est vide";

  static const str_text_field_label_text = "Accés direct";
  static const String str_type_salarie = "salarieType";
  static const String str_type_site = "siteType";
  static const String str_type_vacation = "vacationType";

  ///
  ///home planning screen
  static const String str_salarie = "salarie";
  static const String str_vacation = "vacation";
  static const String str_ready_to_scan = "Ready to Scan";
  static const String str_your_device_dont_support_nfc =
      "Your Device Don't support NFC";
  static const String str_please_turn_on_nfc_service =
      "Please Turn On NFC service in your device";
  static const String str_nfc_disabled =
      "NFC Tag Permission is disabled please enable NFC permission and try Again";

  static const String str_hold_your_device_near_the_nfc_tag =
      "Hold your device near The NFC Tag";

  static const String str_filtrer = "Filtrer";
  static const String str_detail_contact = "Détail du Contrat";
  static const String str_document_administratif = "Document Administratif";
  static const String str_tous = "Tous";

  static const String str_planning = "planning";
  static const String str_planning_non_consulter = "Plannings non consultés";
  static const String str_documents_de_lentreprise =
      "Documents de l'entreprise";

  static const String str_prise_de_vacations = "prise de vacation";
  static const String str_list_des_vacations = "liste des vacations";
  static const String str_demander_refuser = "Demander/Refuser";

  static const String str_list_des_absences = "liste des absences";
  static const String str_preferences = "préferences";
  static const String str_file_uploaded_with_success =
      "fichier téléchargé avec succès";
  static const String str_consultation = "Consultation";
  static const String str_consulter = "Consulter";
  static const String str_telechargement = "Téléchargement";
  static const String str_publication = "Publication";
  static const String str_telecharger = "Télécharger";
  static const String str_afficher = "Afficher";

  static const String str_pdf = "PDF";
  static const String str_details_vacation = "Détail Vacation";

  static const String str_mois_de_selection = "Mois de sélection";
  static const String str_planning_du_mois = "Planning du mois";

  static const String str_agenda = "agenda";

  static const String str_no_site = "il y'a aucune site";

  ///
  ///Home quick access
  static const String str_evaluation_sur_site = "évaluation sur site";
  static const String str_type = "Type";
  static const String str_type_jour = "Type de jour";
  static const String str_type_document = "Type document";

  static const String str_type_questionnaire = "type questionnaire";
  static const String str_type_type_questionnaire = "type TypeQuestionnaire";

  static const String str_departement = "Département";

  static const String str_questionnaire = "questionnaire";
  static const String str_charger = "charger";
  static const String str_periodique = "Périodique";
  static const String str_utilisateur = "Utilisateur";
  static const String str_libre = "Libre";
  static const String str_du = "du";

  /// Home quick access controller
  static const String str_no_salarie = "il y'a aucune salarie";
  static const String str_remplie_cases = "remplie les casses";

  //// list salarie screen
  static const String str_selectioner_salarie = "Séléctionner un salarie";
  static const String str_no_item = "il n'y a aucun item";

  ///list salarie controller
  static const String str_no_type_questions =
      "il n'y a aucun type de questions";

  ///Formulaire Widget
  static const String str_memo1 = "memo 1";
  static const String str_memo2 = "memo 2";
  static const String str_memo3 = "memo 3";
  static const String str_note_updated = "Note mise a jour";
  static const String str_error_send_data =
      "erreur lors de l'envoi des données";
  static const String str_non_applicable_bool_updated =
      "Non applicable mise a jour";
  static const String str_non_applicable = "Non applicable";
  static const String str_coeff = "Coeff";
  static const String str_action_corrective = "Action Corrective";
  static const String str_immediate_bool_updated = "immédiate mise a jour";
  static const String str_immediate = "immédiate";
  static const String str_differer_bool_updated = "differer mise a jour";
  static const String str_differer = "differer";
  static const String str_memo = "Mémo";
  static const String str_date_updated = "date mise a jour";
  static const String str_comment_updated = "commentaire mise a jour";
  static const String str_comment = "Commentaire";
  static const String str_photo = "Photo";
  static const String str_suivant = "Suivant";
  static const String str_precedent = "Précédent";

  static const String str_no_other_item = "aucun autre article";
  ////ADD Image screen
  static const String str_add_images = "Ajouter des Images";
  static const String str_no_image = "il n'y a pas d'image";
  static const String str_valider = "Valider";
  static const String str_valider_le = "Validé Le";
  static const String str_enregistrer = "Enregistrer";
  static const String str_code_pin_oublier = "Code PIN oublié ?";
  static const String str_code_pin_wrong = "Incorrect code PIN";
  static const String str_action_non_autoriser = "Action non-autorisé";

  static const String str_nouvelle_connexion = "Nouvelle connexion";

  static const String str_please_upload_image = "Veuillez télécharger l'image";
  static const String str_glisser_pour_ouvrir = "glisser pour ouvrir";

  ///ADD Image COntroller
  static const String str_image_added = "Image ajouté avec success";
  static const String str_image_not_added = "Image n'est pas était ajouté";
  static const String str_image_deleted = "Image Supprimer avec success";
  static const String str_deleted_with_success = "Supprimer avec success";
  static const String str_updated_with_success = "Modifier avec success";

  static const String str_are_you_sure_want_delete =
      "étez-vous sur de bien vouloir supprimer cet élément ?";

  static const String str_image_not_deleted = "Image n'est pas était Supprimer";
  static const String str_from_camera = "depuis la caméra";
  static const String str_from_gallerie = "depuis la galerie";

  ///Signature screen
  static const String str_signatur = "Signature";
  static const String str_definitif = "Définitif";
  static const String str_ignorer = "Ignorer";

  //Signature controller
  static const String str_empty_signature = "Signature vide";
  static const String str_signature_uploaded = "signature bien télécharger !";
  static const String str_evaluation_ajouter = "Evaluation bien Ajouté";
  static const String str_signature_neccessaire =
      "La Signature est néccessaire pour faire cette action";

  /// select item quick acccess
  static const String str_no_item_selected = "aucun élément sélectionné";
// formulaire screen
  static const String str_selected_type_questionnaire_controle = "Contrôle";
  static const String str_selected_type_questionnaire_qcm = "QCM";
  static const String str_selected_type_questionnaire_formation = "Formation";
  // qcm widget
  static const String str_operation_effectuer = "opération éffectuer";
  static const String str_choix_multiple = "Choix multiple";
  static const String str_operation_non_autoriser = "opération non autorisée";
// boarding screen
  static const String boarding_1_subtitle =
      "Scannez votre carte pour obtenir votre code rapidement";
  static const String boarding_2_subtitle =
      "Scannez un grand groupe de cartes en peu de temps";
  static const String boarding_3_title = "Téléchargement";
  static const String boarding_3_subtitle =
      "Téléchargez l'ensemble des symboles copiés des cartes";
  static const String boarding_4_subtitle =
      "Aider nous a l'amélioré pour un service meilleur";

  ///home planning
  static const String str_home_page = "page d'accueil";
  static const String str_home = "Accueil";
  static const String str_afficher_historique = "Afficher l'historique";
  static const String str_Welcome = "Bienvenue";
  static const String str_terminer = "terminer";
  static const String str_ecrire_votre_message_ici = "écrire votre message ici";
  static const String str_prise_de_service = "Price Service";

  static const String acceder_info = "Accéder à vos informations";

  static const String vacation_proposer = "Vacation Proposées";
  static const String demander_vacation = "Demander une vacation";
  static const String demander_pris = "Pris";

  static const String demander_acquis = "Acquis";
  static const String mise_au_cet_en_cours = "Mise au CET en cours";
  static const String mise_au_cet_annee_en_cours = "Mise au CET année en cours";
  static const String rachat_cet_en_cours = "Rachat CET en cours";
  static const String rachat_de_cet = "Rachat de CET";
  static const String prise_de_cet_en_cours = "Prise de CET en cours";
  static const String prise_de_cet = "Prise de CET";
  static const String solde_de_cet = "Solde de CET";

  static const String demander_a_venir = "À venir";
  static const String demander_demande_en_cours = "Demandes en cours";
  static const String demander_solde_restant_a_prendre =
      "Solde restant à prendre";

  static const String str_en_attente = "En attente";
  static const String str_accepter = "Accepté";
  static const String str_depasser = "Dépassé";
  static const String kAccepter = "Accepter";
  static const String kSelectedCard = "SelectedCard";
  static const String kSelectedCardResult = "SelectedCardResult";

  static const String str_accepter_le = "Acceptée le";

  static const String str_refuser = "Refusé";
  static const String kRefuser = "Refuser";
  static const String str_geolocaliser = "Géolocaliser";

  static const String str_commentaire_planificateur =
      "Commentaire Planificateur";
  static const String str_commentaire_salarie = "Commentaire Salarie";
  static const String str_creation = "Création";

  static const String str_svp_add_date_debut_fin =
      "svp ajouter la date de debut et fin";

  ///
  ///
  ///
  static const String str_aucune_s19_utiliser = "Aucune S19 utilisé";
  static const String str_server_informations = "Server Informations";
}
