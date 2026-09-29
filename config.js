// ============================================================================
// CONFIGURATION SUPABASE
// ============================================================================

// On utilise le Worker Cloudflare comme pont vers Supabase
// (contourne les blocages réseau de certains opérateurs)
const SUPABASE_URL = "https://lucky-firefly-9e07.nkongjl70.workers.dev";
const SUPABASE_KEY = "sb_publishable_M0k-Z8jxsvP6aYzs5SKVRQ_6c7hI-c3";

// Initialisation du client Supabase (accessible partout dans le site)
const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
