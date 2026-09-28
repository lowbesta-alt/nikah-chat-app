# 🕌 Nikah Chat App

Plateforme internationale de rencontre et de mariage islamique, éthique et sérieuse.

## 📖 Description

Application web permettant aux musulmans et musulmanes du monde entier de se rencontrer dans un cadre respectueux, en vue du mariage, conformément aux valeurs de l'Islam.

## ✨ Fonctionnalités prévues

- 👤 **Profils détaillés** : pseudo, âge, pays, ville, bio, niveau de pratique religieuse, statut matrimonial
- 🔍 **Recherche multicritères** : par pays, ville, âge, genre, niveau de pratique
- 💬 **Messagerie temps réel** (type WhatsApp) :
  - Textes instantanés
  - Photos (avec compression automatique)
  - Messages vocaux (enregistrement via micro)
- 🔒 **Sécurité et pudeur** : chaque conversation est privée et cloisonnée
- 💰 **Freemium contextuel** : 10 messages gratuits par conversation, puis déblocage à 600 FCFA / 1 $ (Mobile Money ou carte)

## 🏗️ Stack technique

| Élément | Technologie |
|---|---|
| Base de données | PostgreSQL (Supabase) |
| Authentification | Supabase Auth |
| Stockage fichiers | Supabase Storage (bucket `chat-media`) |
| Temps réel | Supabase Realtime |
| Paiement | Mobile Money (Fapshi / CinetPay) + Stripe |

## 📁 Structure du projet
