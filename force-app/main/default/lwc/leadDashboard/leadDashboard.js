import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { loadScript } from 'lightning/platformResourceLoader';
import getDashboardData from '@salesforce/apex/LeadDashboardController.getDashboardData';
import CHARTJS from '@salesforce/resourceUrl/chartjs';

export default class LeadDashboard extends NavigationMixin(LightningElement) {

    totalLeads    = 0;
    leadsToday    = 0;
    avgScore      = 0;
    hotLeads      = [];
    hotLeadsCount = 0;
    statusData    = [];
    chartjsLoaded = false;
    dataLoaded    = false;
    chart         = null;

    connectedCallback() {
        loadScript(this, CHARTJS)
            .then(() => {
                this.chartjsLoaded = true;
                this.tryRenderChart();
            })
            .catch(err => console.error('ChartJS load error:', err));
    }

    @wire(getDashboardData)
    wiredData({ data, error }) {
        if (data) {
            this.totalLeads    = data.totalLeads || 0;
            this.leadsToday    = data.leadsToday || 0;
            this.avgScore      = data.avgScore ? Math.round(data.avgScore) : 0;
            this.hotLeads      = data.hotLeads || [];
            this.hotLeadsCount = this.hotLeads.length;
            this.statusData    = data.statusData || [];
            this.dataLoaded    = true;
            this.tryRenderChart();
        }
        if (error) {
            console.error('Dashboard error:', error);
        }
    }

    tryRenderChart() {
        if (!this.chartjsLoaded || !this.dataLoaded) return;
        if (!this.statusData.length) return;

        const canvas = this.template.querySelector('.chart-canvas');
        if (!canvas) return;

        if (this.chart) {
            this.chart.destroy();
        }

        const labels = this.statusData.map(s => s.status || 'Sem status');
        const values = this.statusData.map(s => s.total);
        const colors = ['#6366f1','#10b981','#f59e0b','#ef4444','#3b82f6','#8b5cf6'];

        // eslint-disable-next-line no-undef
        this.chart = new Chart(canvas, {
            type: 'doughnut',
            data: {
                labels,
                datasets: [{
                    data: values,
                    backgroundColor: colors.slice(0, values.length),
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { font: { size: 12 } }
                    }
                }
            }
        });
    }

    handleViewLead(event) {
        const leadId = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: leadId,
                objectApiName: 'Lead',
                actionName: 'view'
            }
        });
    }
}