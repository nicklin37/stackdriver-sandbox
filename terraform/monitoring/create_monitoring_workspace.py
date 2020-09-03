import scrapy
from scrapy.crawler import CrawlerProcess
import sys


project_id = ''
key = ''

class WorkspaceSpider(scrapy.Spider):
    name = "workspace_spider"
    start_url = "https://console.cloud.google.com/monitoring?project={}"

    def start_requests(self):
      print(project_id)
      return [scrapy.FormRequest(self.start_url.format(project_id), headers={'Authorization': 'Bearer {}'.format(key)}, callback=self.parse)]

    def parse(self, response):
      # here you would extract links to follow and return Requests for
      # each of them, with another callback
      print("Am parsing...")
      filename = response.url.split("/")[-1] + '.html'
      with open(filename, 'wb') as f:
        f.write(response.body)
      pass



if __name__ == '__main__':
  try:
    project_id = sys.argv[1]
    key = sys.argv[2]
  except IndexError:
    exit("Missing project ID. Usage: python3 create_monitoring_workspace.py $project_id")

  process = CrawlerProcess()
  process.crawl(WorkspaceSpider)
  process.start()
