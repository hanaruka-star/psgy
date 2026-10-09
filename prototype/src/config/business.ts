export type PtTier = 'bronze' | 'silver' | 'gold' | 'platinum';

export type BusinessConfig = {
  media_expire_days: number;
  upcoming_window: number;
  reschedule_before: number;
  cancel_full_refund_hours: number;
  cancel_half_fee_hours: number;
  cancel_forfeit_hours: number;
  quick_action_revisit: number;
  quick_action_days: number;
  no_show_after: number;
  pt_response_timeout: number;
  completion_confirm_timeout: number;
  review_window_days: number;
  payout_hold_days: number;
  ai_trial_days: number;
  pt_cancel_trust_penalty: number;
  rating_star_map: { unhappy: number; happy: number; love: number };
  trust_score_weights: { rating: number; onTime: number; complete: number };
  fee_pct: Record<PtTier, number>;
  min_withdraw: number;
  tier_names: Record<PtTier, string>;
};

export const defaultBusiness: BusinessConfig = {
  media_expire_days: 15,
  upcoming_window: 60,
  reschedule_before: 60,
  cancel_full_refund_hours: 24,
  cancel_half_fee_hours: 24,
  cancel_forfeit_hours: 2,
  quick_action_revisit: 2,
  quick_action_days: 7,
  no_show_after: 15,
  pt_response_timeout: 24 * 60,
  completion_confirm_timeout: 24 * 60,
  review_window_days: 7,
  payout_hold_days: 3,
  ai_trial_days: 2,
  pt_cancel_trust_penalty: 4,
  rating_star_map: { unhappy: 2, happy: 4, love: 5 },
  trust_score_weights: { rating: 40, onTime: 30, complete: 30 },
  fee_pct: { bronze: 18, silver: 15, gold: 12, platinum: 8 },
  min_withdraw: 200_000,
  tier_names: {
    bronze: 'Bronze',
    silver: 'Silver',
    gold: 'Gold',
    platinum: 'Platinum',
  },
};

export function cancelRefundPct(hoursLeft: number, cfg: BusinessConfig): number {
  if (hoursLeft >= cfg.cancel_full_refund_hours) return 100;
  if (hoursLeft >= cfg.cancel_forfeit_hours) return 50;
  return 0;
}
