# NOTE: Gate = 改札機のイメージ
class Gate < ApplicationRecord
  FARES = [150, 190].freeze

  validates :name, presence: true, uniqueness: true
  validates :station_number, presence: true, uniqueness: true

  scope :order_by_station_number, -> { order(:station_number) }

  def exit?(ticket)
    # 有効なチケットかどうかのチェックをする
    return false if ticket.entered_gate == self

    # 必要な料金とチケットの料金を比較する
    get_fare(ticket) <= ticket.fare
  end

  private

  # チケット料金はstation_numberの差分−1
  def get_fare(ticket)
    from = ticket.entered_gate.station_number
    to = station_number
    distance = (to - from).abs
    return FARES[distance -1]
  end

end
