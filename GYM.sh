#!/usr/bin/env bash
# ================================================
# 🏋️‍♂️ Gym Logger by Touci (v2)
# يسولك على اليوم، العضلات، الوقت... ويحسب العضلات لي ماخدمتيهمش
# ================================================

set -euo pipefail

LOG_DIR="$HOME/gym_logs"
mkdir -p "$LOG_DIR"

read -p "🏷️  شنو اسم اليوم؟ (مثلاً: الاثنين): " DAY
read -p "📅  شنو التاريخ؟ (مثلاً: 12/11/2025): " DATE

# 🗓️ البرنامج الأسبوعي
case "$DAY" in
  "الاثنين"|"الإثنين"|"mond")
    WORKOUT="ظهر ترايسبس عضلات_البطن"
    ;;
  "الثلاثاء"|"tlat")
    WORKOUT="صدر بايسبس فومبرا"
    ;;
  "الأربعاء"|"larb3")
    WORKOUT="راحة"
    ;;
  "الخميس"|"lkhmiss")
    WORKOUT="ظهر ترايسبس عضلات_البطن"
    ;;
  "الجمعة"|"jm3a")
    WORKOUT="صدر بايسبس فومبرا"
    ;;
  "السبت"|"sbt")
    WORKOUT="رجلين كتاف"
    ;;
  *)
    WORKOUT="غير_محدد"
    ;;
esac

echo "💪 البرنامج ديال اليوم: $WORKOUT"

if [[ "$WORKOUT" == "راحة" ]]; then
  echo "😴 اليوم راحة، ماكين لا تمرين لا والو!"
  exit 0
fi

# العضلات اللي خدمها المستخدم
read -p "🦾 شنو العضلات اللي خدمتي اليوم؟ (مثلاً: ظهر ترايسبس): " MUSCLES
read -p "🔢 شحال من تكرار (repetitions) درتي لكل عضلة؟ " REPS
read -p "🔁 شحال من سيري (series) درتي؟ " SERIES

# وقت الدخول والخروج
read -p "⏰ وقت الدخول للجيم (HH:MM): " START
read -p "🏁 وقت الخروج من الجيم (HH:MM): " END

START_SEC=$(date -d "$START" +%s)
END_SEC=$(date -d "$END" +%s)
DURATION_MIN=$(( (END_SEC - START_SEC) / 60 ))

# 🔍 نحسب العضلات اللي ماخدمهمش من برنامج اليوم فقط
MISSED=()
for m in $WORKOUT; do
  if ! echo "$MUSCLES" | grep -q "$m"; then
    MISSED+=("$m")
  fi
done

LOG_FILE="$LOG_DIR/${DATE//\//-}_${DAY}.txt"

{
  echo "==============================="
  echo "📅 التاريخ: $DATE"
  echo "🏷️  اليوم: $DAY"
  echo "💪 البرنامج ديال اليوم: $WORKOUT"
  echo "🦾 العضلات اللي خدمتها: $MUSCLES"
  echo "🔢 عدد التكرارات: $REPS"
  echo "🔁 عدد السيريات: $SERIES"
  echo "⏰ وقت الدخول: $START"
  echo "🏁 وقت الخروج: $END"
  echo "⌛ المدة الكاملة: $DURATION_MIN دقيقة"
  echo "🚫 العضلات اللي ماخدمتيهمش: ${MISSED[*]}"
  echo "==============================="
} >> "$LOG_FILE"

echo "✅ تم حفظ الحصة فـ: $LOG_FILE"
