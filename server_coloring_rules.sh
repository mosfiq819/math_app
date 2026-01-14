# ১. ফোল্ডার তৈরি করুন
mkdir mathsolver-backend
cd mathsolver-backend

# ২. ভার্চুয়াল এনভায়রনমেন্ট তৈরি করুন
python -m venv venv

# ৩. এনভায়রনমেন্ট অ্যাক্টিভেট করুন
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# ৪. প্রয়োজনীয় প্যাকেজ ইনস্টল করুন
pip install -r requirements.txt

# ৫. সার্ভার চালু করুন
python main.py