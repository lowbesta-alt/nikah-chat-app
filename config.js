// ============================================================================
// CONFIGURATION SUPABASE
// ============================================================================

const SUPABASE_URL = "https://euprzrhcmtsmljpgbkr.supabase.co";
const SUPABASE_KEY = "sb_publishable_M0k-Z8jxsvP6aYzs5SKVRQ_6c7hI-c3";

// Initialisation du client Supabase (accessible partout dans le site)
const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
