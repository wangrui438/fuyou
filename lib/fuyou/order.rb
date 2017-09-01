module Fuyou
  class Order
    extend Fuyou::Base

    class << self
      def query(org_id, begin_at = nil, end_at = nil, page = nil, per_page = nil)
        options = {
          customNo: Fuyou.config.custom_id,
          corpAccounts: org_id,
          beginDate: begin_at || Date.yesterday.strftime('%Y-%m-%d'),
          endDate: end_at || Date.today.strftime('%Y-%m-%d'),
          pageNum: page || 1,
          pageSize: per_page || 30
        }

        http_post('/FuyouRest/mjfuguan/queryBusinessOrder', options)
      end
    end
  end
end
