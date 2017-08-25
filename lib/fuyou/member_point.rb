module Fuyou
  class MemberPoint
    extend Fuyou::Base

    class << self
      # 优分购买费率查询
      def rate_info(org_id)
        options = {
          customNo: Fuyou.config.custom_id,
          corpAccounts: org_id
        }
        http_get('/FuyouRest/mjfuguan/fuguanQueryRateInfo', options)
      end

      # 福管企业优分购买下单
      def create(org_id, points, rate, service_charge)
        options = {
          customNo: Fuyou.config.custom_id,
          corpAccounts: org_id,
          goodPoints: points,
          factorage: rate,
          factorageAmount: service_charge,
          customSource: Fuyou.config.custom_source
        }
        http_post('/FuyouRest/mjfuguan/fuguanBuyScore', options)
      end
    end
  end
end
