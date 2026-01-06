# =========================
# 基础体验优化
# =========================

set pagination off
set confirm off
set print pretty on
set print frame-arguments none

# 显示源码行数
set listsize 15

# =========================
# 每次停下时显示本地变量
# =========================

define hook-stop
  echo \n--- locals ---\n
  info locals
end
